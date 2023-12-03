docker-compose --env-file /home/joe/Public/docker/keycloak/env-vars.env -f /home/joe/Public/docker/keycloak/docker-compose.yml up -d
sudo cp /home/joe/Public/docker/lemmy/nginx.conf /etc/nginx/sites-enabled/nginx.conf
sudo service nginx restart