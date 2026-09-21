param(
    [ValidateRange(1, 8)] [int] $FromStep = 1,
    [ValidateRange(1, 8)] [int] $ToStep = 8,
    [switch] $RefreshEchoGO,
    [switch] $SkipPreflight
)

$ErrorActionPreference = 'Stop'
if ($FromStep -gt $ToStep) {
    throw '-FromStep must be less than or equal to -ToStep.'
}

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$resolvedRoot = (Resolve-Path -LiteralPath $projectRoot).Path
$env:HOLTEMME_PROJECT_DIR = $resolvedRoot
$env:HOLTEMME_REFRESH_ECHOGO = if ($RefreshEchoGO) { 'true' } else { 'false' }

$rscript = Get-Command Rscript.exe -ErrorAction SilentlyContinue
if (-not $rscript) {
    $rscript = Get-Command Rscript -ErrorAction SilentlyContinue
}
if (-not $rscript) {
    $fallbacks = @(
        'C:\Program Files\R\R-4.4.3\bin\Rscript.exe',
        'C:\Program Files\R\R-4.4.2\bin\Rscript.exe',
        'C:\Program Files\R\R-4.4.1\bin\Rscript.exe'
    )
    $rscriptPath = $fallbacks | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
    if ($rscriptPath) {
        $rscript = Get-Item -LiteralPath $rscriptPath
    }
}
if (-not $rscript) {
    throw 'Rscript was not found on PATH or in the documented R 4.4 locations.'
}

if (-not $env:RSTUDIO_PANDOC) {
    $pandocCandidates = @(
        'C:\Program Files\RStudio\resources\app\bin\quarto\bin\tools',
        'C:\Program Files\RStudio\bin\pandoc',
        'C:\Program Files\Quarto\bin\tools'
    )
    $pandocDir = $pandocCandidates |
        Where-Object { Test-Path -LiteralPath (Join-Path $_ 'pandoc.exe') } |
        Select-Object -First 1
    if ($pandocDir) {
        $env:RSTUDIO_PANDOC = $pandocDir
    }
}

Push-Location -LiteralPath $resolvedRoot
try {
    if (-not $SkipPreflight) {
        & $rscript.FullName 'scripts/preflight.R' --from $FromStep --to $ToStep --full-inputs
        if ($LASTEXITCODE -ne 0) {
            throw "Workflow preflight failed with exit code $LASTEXITCODE."
        }
    }
    if ($RefreshEchoGO -and $FromStep -le 5 -and $ToStep -ge 5) {
        & $rscript.FullName 'scripts/run_echogo_v014_ecology.R'
        if ($LASTEXITCODE -ne 0) {
            throw "EchoGO 0.1.4 ecology runs failed with exit code $LASTEXITCODE."
        }
    }
    & $rscript.FullName 'scripts/render_all.R' --from $FromStep --to $ToStep
    if ($LASTEXITCODE -ne 0) {
        throw "Workflow rendering failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}


