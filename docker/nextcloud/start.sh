docker-compose -f /home/joe/Public/docker/nextcloud/docker-compose.yml up -d
sudo cp /home/joe/Public/docker/nginx/nginx.conf /etc/nginx/sites-enabled/nginx.conf
sudo service nginx restart