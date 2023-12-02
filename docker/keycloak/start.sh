docker-compose --env-file /home/joe/Public/docker/keycloak/env-vars.env -f /home/joe/Public/docker/keycloak/docker-compose.yml up -d
sudo cp /home/joe/$domainname/nginx.conf /etc/nginx/sites-enabled/nginx.conf
sudo service nginx restart