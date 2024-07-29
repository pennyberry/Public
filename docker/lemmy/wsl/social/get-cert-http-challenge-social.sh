source /home/joe/Public/docker/lemmy/wsl/social/env-vars.env
sudo apt install certbot
now=$(date +'%m-%d-%Y--%H-%M')
domain=${domainname}
logdir=/var/log/${domain}
logname="${now}.log"
log="${logdir}/${logname}"
sudo mkdir ${logdir}
sudo mkdir -p /var/www/certbot
sudo chmod -R 755 /var/www/certbot
sudo touch ${log}
sudo chmod +x ${log}
sudo chown joe:joe ${log}
sudo chmod 755 ${logdir}
sudo chmod 644 ${log}
#sudo certbot certonly --manual --manual-public-ip-logging-ok --preferred-challenges http -d ${domain} >> ${log} 2>&1
sudo certbot certonly --webroot -w /var/www/certbot -d ${domain} >> ${log} 2>&1
sudo cat ${log}

# Move the certificate files to the correct directory
# sudo mv /etc/letsencrypt/live/social.joeberry.org-0005/fullchain.pem /etc/letsencrypt/live/social.joeberry.org/fullchain.pem
# Find folders that keep appending 0004, 0005, etc.
folder=$(sudo find /etc/letsencrypt/live -type d -name "*-[0-9][0-9][0-9][0-9]" | head -n 1)
if [ -d "$folder" ]; then
    # Move the certificate files to the correct directory
    sudo mv "$folder/fullchain.pem" "/etc/letsencrypt/live/social.joeberry.org/fullchain.pem"
    sudo mv "$folder/chain.pem" "/etc/letsencrypt/live/social.joeberry.org/chain.pem"
    sudo mv "$folder/cert.pem" "/etc/letsencrypt/live/social.joeberry.org/cert.pem"
    sudo mv "$folder/privkey.pem" "/etc/letsencrypt/live/social.joeberry.org/privkey.pem"
    # Update permissions if needed
    sudo chmod 600 /etc/letsencrypt/live/social.joeberry.org/fullchain.pem /etc/letsencrypt/live/social.joeberry.org/privkey.pem
    sudo rm -rf "$folder"
    # Reload or restart Nginx to apply the changes
    sudo systemctl reload nginx
else
    echo "folder not found. no action required"
fi