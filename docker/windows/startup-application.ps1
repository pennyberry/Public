$logfile = "C:\Users\Pineapple\Desktop\startup.txt"
Remove-Item -Force $logfile
Start-Transcript -Path $logfile
function IsDockerRunning {
    $dockerProcess = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue
    if ($dockerProcess -ne $null) {
        return $true
    } else {
        return $false
    }
}

#wait for docker to start
$maxWaitSeconds = 90
$startTime = Get-Date
$timeoutReached = $false
Write-Host "Waiting for Docker to start..."
while (-not (IsDockerRunning) -and (-not $timeoutReached)) {
    if ((Get-Date) -ge ($startTime).AddSeconds($maxWaitSeconds)) {
        $timeoutReached = $true
    }
    Start-Sleep -Seconds 1
}

if ($timeoutReached) {
    Write-Error "Timeout reached. Docker did not start within $maxWaitSeconds seconds."
    Stop-Transcript -Path $logfile
    exit 99
}
#wait for containers to start
$containerFound = $false
while ((Get-Date) -lt ($startTime).AddSeconds($maxWaitSeconds) -and (-not $containerFound)) {
    $runningContainers = docker ps --format "{{.Names}}"
    if ($runningContainers) {
        $containerFound = $true
    }
    Start-Sleep -Seconds 1
}

if ($containerFound) {
    Write-Host "At least one container is running. Continuing"
} else {
    Write-Error "No containers are running within the last $loopDurationSeconds seconds."
    Stop-Transcript -Path $logfile
    exit 99
}


#port forward to wsl
$wsl_ip = wsl -- ip -o -4 -json addr list eth0 | ConvertFrom-Json | %{ $_.addr_info.local } | ?{ $_ }
netsh interface portproxy delete v4tov4 listenport=443 listenaddress=0.0.0.0
netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=443 connectaddress=$wsl_ip connectport=443
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=80 connectaddress=$wsl_ip connectport=80

#startup app inside wsl
wsl bash -c ('echo 1 | sudo -S chmod +x /home/joe/Public/docker/keycloak/start.sh')
wsl bash -c ('echo 1 | sudo -S chmod +x /home/joe/Public/docker/portainer/start.sh')
wsl bash -c ('cd /home/joe/Public/docker/portainer ;. start.sh')
wsl bash -c ('cd /home/joe/Public/docker/keycloak ;. start.sh')
wsl.exe docker-compose --env-file /home/joe/Public/docker/lemmy/env-vars.env -f /home/joe/Public/docker/lemmy/docker-compose.yml up -d
wsl bash -c ('sudo -S service nginx restart <<< 1' -replace '"', '\"')

Stop-Transcript