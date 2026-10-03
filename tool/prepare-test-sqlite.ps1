# Windows system winsqlite3 can omit foreign-key support. Tests use official SQLite.
# The mobile app gets its SQLite library from drift_flutter, not this test helper.
$ErrorActionPreference = 'Stop'
if (-not $IsWindows) { return }
if ([System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture -ne 'X64') {
    throw 'This test-library helper supports Windows x64. Use a compatible SQLite DLL on other architectures.'
}
$testRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$testSqlite = Join-Path $testRoot '.dart_tool\test-sqlite'
New-Item -ItemType Directory -Force -Path $testSqlite | Out-Null
$testArchive = Join-Path $testSqlite 'sqlite.zip'
$testHash = '8B959B7EFF4A81F6A62FC3468F9273E5CFE78D4A927E62215AED231B654FB104'
if (-not (Test-Path -LiteralPath $testArchive) -or
    (Get-FileHash -LiteralPath $testArchive -Algorithm SHA256).Hash -ne $testHash) {
    Invoke-WebRequest 'https://www.sqlite.org/2026/sqlite-dll-win-x64-3530400.zip' -OutFile $testArchive
}
if ((Get-FileHash -LiteralPath $testArchive -Algorithm SHA256).Hash -ne $testHash) {
    throw 'SQLite archive integrity check failed.'
}
# Extract only the known library entry; no archive-provided path is used.
Add-Type -AssemblyName System.IO.Compression.FileSystem
$testZip = [IO.Compression.ZipFile]::OpenRead($testArchive)
try {
    $testEntry = $testZip.GetEntry('sqlite3.dll')
    if ($null -eq $testEntry) { throw 'SQLite library missing from archive.' }
    [IO.Compression.ZipFileExtensions]::ExtractToFile($testEntry, (Join-Path $testSqlite 'sqlite3.dll'), $true)
} finally { $testZip.Dispose() }
Write-Output 'Official SQLite 3.53.4 prepared for Windows x64 tests.'
