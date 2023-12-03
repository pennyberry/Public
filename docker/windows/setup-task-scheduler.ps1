mkdir c:\Scripts\WSL\EnableLemmy

#get env vars
wsl cat /home/joe/Public/docker/lemmy/wsl/env-vars.env | foreach {
    $name, $value = $_.split('=')
    set-content env:\$name $value
}

wsl cp /home/joe/Public/docker/windows/startup-application.ps1 /mnt/c/Scripts/WSL/EnableLemmy/startup-application.ps1
$scriptPath = "C:\Scripts\WSL\EnableLemmy\startup-application.ps1"
$actionParams = "-ExecutionPolicy Bypass -File $scriptPath"
$taskAction = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument $actionParams
$taskTrigger = New-ScheduledTaskTrigger -AtLogon
$STPrin = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -TaskName "Startup Lemmy" -Description "Starts Up Lemmy when computer turns on" -Principal $STPrin