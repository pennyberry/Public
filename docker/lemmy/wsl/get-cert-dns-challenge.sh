source /home/joe/Public/docker/lemmy/wsl/env-vars.env
sudo apt install certbot
sudo certbot certonly --manual --preferred-challenges dns -d ${domainname}