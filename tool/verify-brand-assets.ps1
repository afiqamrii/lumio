$ErrorActionPreference = 'Stop'
$assetRoot = Join-Path (Split-Path -Parent $PSScriptRoot) 'lumio-assets'
$manifest = Get-Content -LiteralPath (Join-Path $assetRoot 'MANIFEST.json') -Raw | ConvertFrom-Json
$failures = @()
foreach ($file in $manifest.files) {
    $path = Join-Path $assetRoot $file.path
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $failures += $file.path
        continue
    }
    $actual = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actual -ne $file.sha256) { $failures += $file.path }
}
if ($failures.Count -gt 0) {
    throw ('Brand asset verification failed: ' + ($failures -join ', '))
}
Write-Output ('Verified ' + $manifest.files.Count + ' original brand files; all SHA-256 hashes match.')
