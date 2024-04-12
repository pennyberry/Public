#wait
write-host waiting for boot up of wsl
Wait-Event -Timeout 90

#port forward to wsl
$wsl_ip = wsl -- ip -o -4 -json addr list eth0 | ConvertFrom-Json | %{ $_.addr_info.local } | ?{ $_ }
netsh interface portproxy delete v4tov4 listenport=443 listenaddress=0.0.0.0
netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=443 connectaddress=$wsl_ip connectport=443
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=80 connectaddress=$wsl_ip connectport=80

#startup app inside wsl
wsl.exe docker-compose --env-file /home/joe/Public/docker/lemmy/env-vars.env -f /home/joe/Public/docker/lemmy/docker-compose.yml up -d
wsl bash -c ('echo 1 | sudo -S chmod +x /home/joe/Public/docker/keycloak/start.sh')
wsl bash -c ('echo 1 | sudo -S chmod +x /home/joe/Public/docker/portainer/start.sh')
wsl bash -c ('cd /home/joe/Public/docker/portainer ;. start.sh')
wsl bash -c ('cd /home/joe/Public/docker/keycloak ;. start.sh')

#wsl bash -c ('sudo -S service nginx restart <<< 1' -replace '"', '\"')
