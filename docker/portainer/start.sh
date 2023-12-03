source env-vars.env
echo $adminpassword > /home/joe/Public/docker/portainer/portainer_password.secrets
docker-compose --env-file /home/joe/Public/docker/portainer/env-vars.env -f /home/joe/Public/docker/portainer/docker-compose.yml up -d