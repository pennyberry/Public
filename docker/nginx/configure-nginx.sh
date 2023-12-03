sudo docker-compose up -d
sleep 5
sudo apt install nginx
#wget https://raw.githubusercontent.com/LemmyNet/lemmy-ansible/main/templates/nginx.conf
#edit this file
sudo cp /home/joe/Public/docker/nginx/nginx.conf /etc/nginx/sites-enabled/nginx.conf
sudo nginx -s reload
sudo service nginx restart
#if running WSL remember to port forward in windows CMD