source env-vars.env
docker-compose up -d
sudo cp /home/joe/$domainname/nginx.conf /etc/nginx/sites-enabled/nginx.conf
sudo service nginx restart