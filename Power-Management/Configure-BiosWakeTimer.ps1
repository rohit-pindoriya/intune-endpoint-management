$ErrorActionPreference = "Stop"

try {
    # 1. Enable the Wake Up On Alarm feature and set it to Daily
    Invoke-WmiMethod -Namespace "root\wmi" -Class "Lenovo_SetBiosSetting" -Name "SetBiosSetting" -ArgumentList "WakeUpOnAlarm,Daily"
    
    # 2. Set the Wake Up Time to 06:00:00 (6:00 AM)
    Invoke-WmiMethod -Namespace "root\wmi" -Class "Lenovo_SetBiosSetting" -Name "SetBiosSetting" -ArgumentList "AlarmTime,06:00:00"
    
    # 3. Save the changes to the BIOS so they persist after reboot
    Invoke-WmiMethod -Namespace "root\wmi" -Class "Lenovo_SaveBiosSettings" -Name "SaveBiosSettings"
    
    Write-Output "Lenovo BIOS Wake Alarm successfully configured for 6:00 AM."
} catch {
    Write-Error "Failed to update BIOS: $($_.Exception.Message)"
}
