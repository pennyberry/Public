sudo apt install nginx
#wget https://raw.githubusercontent.com/LemmyNet/lemmy-ansible/main/templates/nginx.conf
#edit this file
sudo cp /home/joe/Public/docker/nginx/nginx.conf /etc/nginx/sites-enabled/nginx.conf
sudo rm /var/www/html/index.nginx-debian.html
sudo cp /home/joe/Public/docker/nginx/index.html /var/www/html/index.html
sudo service nginx restart