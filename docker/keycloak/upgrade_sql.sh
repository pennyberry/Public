#add new postgres-new container to docker-compose.yml as a clone of postgres

source /home/joe/Public/docker/keycloak/env-vars.env
sudo su
old=$(docker ps -q -f name=keycloak-postgres-1)
new=$(docker ps -q -f name=keycloak-postgres-new-1)
path='/home/joe/Public/docker/keycloak/backup.sql'
docker exec -it $old pg_dumpall -U $pgdb > $path
cat $path | docker exec -i $new psql -U $pgdb

#update depends-on in docker-compose.yml to point to new container
#validate uptime

#remove old container in docker-compose.yml
#validate uptime

#remove backup
#rm $path

#validate uptime