# =========================================================================
# McAfee & WebAdvisor Full Removal Script
# =========================================================================

# 1. Stop browsers to unlock WebAdvisor files
$Browsers = "msedge", "chrome", "firefox"
Stop-Process -Name $Browsers -Force -ErrorAction SilentlyContinue

# 2. Stop all McAfee services
$Services = Get-Service -Name "McAfee*", "mfefire", "mfevtp" -ErrorAction SilentlyContinue
foreach ($service in $Services) {
    Stop-Service $service.Name -Force -ErrorAction SilentlyContinue
    Set-Service $service.Name -StartupType Disabled -ErrorAction SilentlyContinue
}

# 3. Find and uninstall McAfee programs via Registry
$Paths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", 
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
$Apps = Get-ItemProperty -Path $Paths -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match "McAfee" }

foreach ($App in $Apps) {
    $Uninst = $App.UninstallString
    if ([string]::IsNullOrWhiteSpace($Uninst)) { continue }

    # If it is an MSI installer
    if ($Uninst -match "msiexec") {
        $MSIArgs = $Uninst -replace "(?i)msiexec\.exe\s*", "" -replace "(?i)/I", "/X"
        $MSIArgs = $MSIArgs + " /qn /norestart"
        Start-Process -FilePath "msiexec.exe" -ArgumentList $MSIArgs -Wait -NoNewWindow
    } 
    # If it is a standard EXE
    else {
        $ExePath = $Uninst -replace '"', ''
        if (Test-Path $ExePath) {
            Start-Process -FilePath $ExePath -ArgumentList "/s", "/quiet", "/norestart" -Wait -NoNewWindow
        }
    }
}

# 4. Explicit WebAdvisor/SiteAdvisor uninstallation (Targeted fallback)
$WebAdvisorPaths = @(
    "C:\Program Files\McAfee\WebAdvisor\uninstaller.exe",
    "C:\Program Files (x86)\McAfee\WebAdvisor\uninstaller.exe",
    "C:\Program Files (x86)\McAfee\SiteAdvisor\Uninstall.exe"
)

foreach ($path in $WebAdvisorPaths) {
    if (Test-Path $path) {
        Start-Process -FilePath $path -ArgumentList "/s" -Wait -NoNewWindow
    }
}

# 5. Clean up leftover directories
$Folders = @(
    "$env:ProgramFiles\McAfee", 
    "${env:ProgramFiles(x86)}\McAfee", 
    "$env:ProgramData\McAfee"
)
foreach ($folder in $Folders) {
    if (Test-Path $folder) { 
        Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue 
    }
}
