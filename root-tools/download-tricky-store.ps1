$ErrorActionPreference = "Stop"

$Name = "Tricky-Store-v1.4.1-245-72b2e84-release.zip"
$Url = "https://github.com/5ec1cff/TrickyStore/releases/download/1.4.1/$Name"
$Expected = "2f5e73fcba0e4e43b6e96b38f333cbe394873e3a81cf8fe1b831c2fbd6c46ea9"
$Output = if ($args.Count -gt 0) { $args[0] } else { $Name }
$Part = "$Output.part"

Invoke-WebRequest -Uri $Url -OutFile $Part
$Actual = (Get-FileHash -Algorithm SHA256 $Part).Hash.ToLowerInvariant()
if ($Actual -ne $Expected) {
    Remove-Item -Force $Part
    throw "SHA-256 mismatch: expected $Expected, got $Actual"
}
Move-Item -Force $Part $Output
Write-Host "Saved verified upstream file: $Output"
