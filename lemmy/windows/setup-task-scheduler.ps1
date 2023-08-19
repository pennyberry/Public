mkdir c:\Scripts\WSL\EnableLemmy
wsl cp /home/joe/example.domain.com/windows/startup-application.ps1 /mnt/c/Scripts/WSL/EnableLemmy/startup-application.ps1
$scriptPath = "C:\Scripts\WSL\EnableLemmy\startup-application.ps1"
$actionParams = "-ExecutionPolicy Bypass -File $scriptPath"
$taskAction = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument $actionParams
$taskTrigger = New-ScheduledTaskTrigger -AtLogon
$STPrin = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -TaskName "Startup Lemmy" -Description "Starts Up Lemmy when computer turns on" -Principal $STPrin