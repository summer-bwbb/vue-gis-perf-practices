param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath
)

$ErrorActionPreference = "SilentlyContinue"
$srcPath = Join-Path $ProjectPath "src"
if (-not (Test-Path $srcPath)) {
    Write-Error "src/ not found at $srcPath"
    exit 1
}

function Get-DirStats {
    param([string]$Path, [string[]]$Extensions)
    $files = Get-ChildItem -Path $Path -Recurse -Include $Extensions -File
    if (-not $files) { return @{ Count = 0; SizeMB = 0 } }
    $sum = ($files | Measure-Object Length -Sum).Sum
    return @{ Count = $files.Count; SizeMB = [math]::Round($sum / 1MB, 2) }
}

function Get-LargestFiles {
    param([string]$Path, [string[]]$Extensions, [int]$Top = 10)
    Get-ChildItem -Path $Path -Recurse -Include $Extensions -File |
        Sort-Object Length -Descending |
        Select-Object -First $Top |
        ForEach-Object {
            @{
                Name = $_.FullName.Replace($Path + "\", "")
                SizeKB = [math]::Round($_.Length / 1KB, 1)
            }
        }
}

function Count-Pattern {
    param([string]$Path, [string]$Pattern)
    $matches = Select-String -Path (Get-ChildItem -Path $Path -Recurse -Include "*.vue","*.ts","*.js" -File | ForEach-Object { $_.FullName }) -Pattern $Pattern -SimpleMatch:$false
    if (-not $matches) { return 0 }
    return $matches.Count
}

function Count-PatternFiles {
    param([string]$Path, [string]$Pattern)
    $matches = Select-String -Path (Get-ChildItem -Path $Path -Recurse -Include "*.vue","*.ts","*.js" -File | ForEach-Object { $_.FullName }) -Pattern $Pattern -SimpleMatch:$false
    if (-not $matches) { return 0 }
    return ($matches | Select-Object -ExpandProperty Path -Unique).Count
}

# --- Package.json ---
$pkgPath = Join-Path $ProjectPath "package.json"
$pkg = $null
if (Test-Path $pkgPath) {
    $pkg = Get-Content $pkgPath -Raw | ConvertFrom-Json
}

# --- File category stats ---
$source = Get-DirStats -Path $srcPath -Extensions "*.vue","*.ts","*.js","*.jsx","*.tsx"
$styles = Get-DirStats -Path $srcPath -Extensions "*.scss","*.css","*.less","*.sass"
$images = Get-DirStats -Path $srcPath -Extensions "*.png","*.jpg","*.jpeg","*.gif","*.webp","*.avif"
$vectors = Get-DirStats -Path $srcPath -Extensions "*.svg"
$fonts = Get-DirStats -Path $srcPath -Extensions "*.ttf","*.TTF","*.woff","*.woff2","*.eot","*.otf"
$other = Get-DirStats -Path $srcPath -Extensions "*.json","*.html","*.md","*.txt"
$totalSrc = (Get-ChildItem -Path $srcPath -Recurse -File | Measure-Object Length -Sum).Sum

# --- Largest source files ---
$largestVue = Get-LargestFiles -Path $srcPath -Extensions "*.vue" -Top 10
$largestTs = Get-LargestFiles -Path $srcPath -Extensions "*.ts" -Top 5

# --- Metric counts ---
$metrics = @{
    shallowRef = Count-PatternFiles -Path $srcPath -Pattern "shallowRef"
    cesiumFiles = Count-PatternFiles -Path $srcPath -Pattern "from ['x22]cesium|Cesium\.Viewer|new Cesium|Cesium\."
    addEventListener = Count-Pattern -Path $srcPath -Pattern "addEventListener"
    removeEventListener = Count-Pattern -Path $srcPath -Pattern "removeEventListener"
    setInterval = Count-Pattern -Path $srcPath -Pattern "setInterval"
    setTimeout = Count-Pattern -Path $srcPath -Pattern "setTimeout"
    onUnmounted = Count-Pattern -Path $srcPath -Pattern "onUnmounted|onBeforeUnmount"
    destroyCalls = Count-Pattern -Path $srcPath -Pattern "\.destroy\(\)"
    refLarge = Count-Pattern -Path $srcPath -Pattern "= ref\(|=ref\("
    vueFilesOver30k = (Get-ChildItem -Path $srcPath -Recurse -Include "*.vue" -File | Where-Object { $_.Length -gt 30000 }).Count
}

# --- Key config files ---
$viteConfig = $null
$vitePath = Join-Path $ProjectPath "vite.config.ts"
if (Test-Path $vitePath) {
    $viteConfig = Get-Content $vitePath -Raw
}

$eslintrc = $null
$eslintPath = Join-Path $ProjectPath ".eslintrc.cjs"
if (Test-Path $eslintPath) {
    $eslintrc = Get-Content $eslintPath -Raw
}

# --- Output ---
$result = @{
    projectPath = $ProjectPath
    projectName = (Split-Path $ProjectPath -Leaf)
    scanTime = (Get-Date -Format "yyyy-MM-dd HH:mm")
    package = @{
        name = $pkg.name
        version = $pkg.version
        dependencies = @{}
        devDependencies = @{}
    }
    fileStats = @{
        source = $source
        styles = $styles
        images = $images
        vectors = $vectors
        fonts = $fonts
        other = $other
        totalMB = [math]::Round($totalSrc / 1MB, 2)
    }
    largestFiles = @{
        vue = $largestVue
        ts = $largestTs
    }
    metrics = $metrics
    config = @{
        hasManualChunks = ($viteConfig -match "manualChunks")
        hasEchartsImport = ($viteConfig -match "echarts")
        hasCesiumPlugin = ($viteConfig -match "cesium|vite-plugin-cesium")
        hasElementPlusAutoImport = ($viteConfig -match "unplugin|ElementPlusResolver")
        viteConfigSnippet = if ($viteConfig) { $viteConfig.Substring(0, [Math]::Min(2000, $viteConfig.Length)) } else { $null }
    }
}

if ($pkg.dependencies) {
    $pkg.dependencies.PSObject.Properties | ForEach-Object {
        $result.package.dependencies[$_.Name] = $_.Value
    }
}
if ($pkg.devDependencies) {
    $pkg.devDependencies.PSObject.Properties | ForEach-Object {
        $result.package.devDependencies[$_.Name] = $_.Value
    }
}

$result | ConvertTo-Json -Depth 10