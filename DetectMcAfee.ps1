# =========================================================================
# McAfee Custom Detection Script
# =========================================================================

$Paths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", 
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
$McAfeeRegistry = Get-ItemProperty -Path $Paths -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match "McAfee" }

$Folder1 = Test-Path "$env:ProgramFiles\McAfee"
$Folder2 = Test-Path "${env:ProgramFiles(x86)}\McAfee"
$Folder3 = Test-Path "$env:ProgramData\McAfee"

if ($McAfeeRegistry -or $Folder1 -or $Folder2 -or $Folder3) {
    # McAfee or WebAdvisor is still present. Trigger enforcement.
    Exit 1
} else {
    # The device is clean. Mark as Compliant/Installed.
    Write-Output "Clean"
    Exit 0
}