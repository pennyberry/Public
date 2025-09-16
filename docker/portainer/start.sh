#sudo rm -rf /home/joe/Public/docker/portainer/volumes
source /home/joe/Public/docker/portainer/env-vars.env
export PORTAINERADMINPASSWORD="$(docker run --rm httpd:2.4-alpine htpasswd -nbB admin $adminpassword | cut -d ":" -f 2)"
#docker-compose --env-file /home/joe/Public/docker/portainer/env-vars.env -f /home/joe/Public/docker/portainer/docker-compose.yml down
docker compose --env-file /home/joe/Public/docker/portainer/env-vars.env -f /home/joe/Public/docker/portainer/docker-compose.yml up -d