$ErrorActionPreference = "Stop"

Write-Host "[Linudex] Android 12 Phantom Process Killer workaround"
Write-Host "[Linudex] This configuration is intentionally temporary and may reset after reboot."
Write-Host ""

if (-not (Get-Command adb -ErrorAction SilentlyContinue)) {
    Write-Error "adb was not found in PATH. Install Android Platform Tools and try again."
    exit 1
}

$devices = adb devices
$connected = $devices | Select-String -Pattern "\tdevice$"

if (-not $connected) {
    Write-Error "No authorized Android device was detected by adb."
    exit 1
}

Write-Host "[Linudex] Current max_phantom_processes value:"
adb shell "/system/bin/device_config get activity_manager max_phantom_processes"

Write-Host ""
Write-Host "[Linudex] Disabling DeviceConfig sync until reboot..."
adb shell "/system/bin/device_config set_sync_disabled_for_tests until_reboot"

Write-Host "[Linudex] Raising the phantom-process limit for this test session..."
adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"

Write-Host ""
Write-Host "[Linudex] New max_phantom_processes value:"
adb shell "/system/bin/device_config get activity_manager max_phantom_processes"

Write-Host ""
Write-Host "[Linudex] Done. Rebooting the phone may revert this test configuration."
