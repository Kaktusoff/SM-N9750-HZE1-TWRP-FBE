$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$PackageName = "com.idamob.tinkoff.android"
$SourcePath = "/sdcard/TWRP"
$BackupRoot = "/sdcard/RecoveryBackups"
$AdbExecutable = if ([string]::IsNullOrWhiteSpace($env:ADB)) { "adb" } else { $env:ADB }

function Invoke-AdbChecked {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    $Output = & $script:AdbExecutable @Arguments 2>&1
    $ExitCode = $LASTEXITCODE
    if ($ExitCode -ne 0) {
        $Details = ($Output | Out-String).Trim()
        if ([string]::IsNullOrWhiteSpace($Details)) {
            $Details = "no diagnostic output"
        }
        throw "adb $($Arguments -join ' ') failed with exit code ${ExitCode}: $Details"
    }
    return $Output
}

function Invoke-RemoteText {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    return ((Invoke-AdbChecked -Arguments @("shell", $Command) | Out-String).Trim())
}

if (-not (Get-Command $AdbExecutable -ErrorAction SilentlyContinue)) {
    throw "adb was not found. Install Android Platform Tools or set ADB to its full path."
}

& $AdbExecutable start-server 1>$null 2>$null
if ($LASTEXITCODE -ne 0) {
    throw "adb start-server failed with exit code $LASTEXITCODE."
}

$DeviceState = (& $AdbExecutable get-state 2>$null | Out-String).Trim()
if ($LASTEXITCODE -ne 0) {
    throw "adb get-state failed. Connect exactly one authorized Android device."
}
if ($DeviceState -ne "device") {
    throw "Exactly one authorized Android device must be connected (current state: $DeviceState)."
}

Write-Host "Stopping only $PackageName..."
Invoke-AdbChecked -Arguments @("shell", "am", "force-stop", $PackageName) | Out-Null

$SourceKind = Invoke-RemoteText -Command "if [ -d '$SourcePath' ]; then printf directory; elif [ -e '$SourcePath' ]; then printf other; else printf absent; fi"
switch ($SourceKind) {
    "absent" {
        Write-Host "$SourcePath is absent; the known T-Bank biometric root trigger is already clear."
        Write-Host "Open T-Bank manually and check biometric sign-in."
        exit 0
    }
    "directory" { }
    "other" {
        throw "$SourcePath exists but is not a directory; it was left untouched."
    }
    default {
        throw "Could not determine the state of $SourcePath (response: $SourceKind)."
    }
}

Invoke-AdbChecked -Arguments @("shell", "mkdir -p '$BackupRoot' && [ -d '$BackupRoot' ]") | Out-Null

$Destination = $null
for ($Attempt = 1; $Attempt -le 20; $Attempt++) {
    $Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $Candidate = "$BackupRoot/TWRP-$Timestamp"
    $CandidateState = Invoke-RemoteText -Command "if [ -e '$Candidate' ]; then printf exists; else printf free; fi"
    if ($CandidateState -eq "free") {
        $Destination = $Candidate
        break
    }
    if ($CandidateState -ne "exists") {
        throw "Could not check destination $Candidate."
    }
    Start-Sleep -Seconds 1
}

if ([string]::IsNullOrWhiteSpace($Destination)) {
    throw "Could not allocate a unique timestamped backup path. Nothing was moved."
}

$MoveCommand = "if [ -e '$Destination' ]; then printf 'destination collision' >&2; exit 73; fi; mv -n '$SourcePath' '$Destination'"
Invoke-AdbChecked -Arguments @("shell", $MoveCommand) | Out-Null

$Verification = Invoke-RemoteText -Command "if [ ! -e '$SourcePath' ] && [ -d '$Destination' ]; then printf ok; else printf failed; fi"
if ($Verification -ne "ok") {
    throw "Post-move verification failed; inspect $SourcePath and $Destination before continuing."
}

Write-Host "Done: moved the complete directory without deleting it:"
Write-Host "  $SourcePath"
Write-Host "  -> $Destination"
Write-Host "Open T-Bank manually and check biometric sign-in. TWRP may recreate $SourcePath after recovery use; rerun this helper if needed."
