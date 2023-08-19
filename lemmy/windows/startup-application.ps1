#wait
write-host waiting for boot up of wsl
Wait-Event -Timeout 20
#port forward to wsl
$wsl_ip = (wsl hostname -I).trim()
netsh interface portproxy delete v4tov4 listenport=443 listenaddress=0.0.0.0
netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=443 connectaddress=$wsl_ip connectport=443
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=80 connectaddress=$wsl_ip connectport=80

#startup app inside wsl
wsl.exe docker-compose -f /home/joe/example.domain.com/docker-compose.yml up -d
wsl.exe sleep 8
#wget https://raw.githubusercontent.com/LemmyNet/lemmy-ansible/main/templates/nginx.conf
#edit this file
$script = 'sudo -S service nginx restart <<< ENTER-LINUX-SUDO-PW-HERE'
wsl bash -c ($script -replace '"', '\"')