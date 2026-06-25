# Define the action: Shut down the computer with a 60-second warning countdown
$Action = New-ScheduledTaskAction -Execute 'shutdown.exe' -Argument '/s /t 60 /f /c "Nightly Automated Shutdown"'

# Define the trigger: Run daily at 8:00 PM
$Trigger = New-ScheduledTaskTrigger -Daily -At "8:00PM"

# Register the task in Windows to run as the SYSTEM account
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "NightlyAutoShutdown" -Description "Shuts down the PC automatically every evening." -User "NT AUTHORITY\SYSTEM" -RunLevel Highest -Force
