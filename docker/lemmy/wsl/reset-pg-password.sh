source env-vars.env
command="ALTER USER lemmy WITH PASSWORD '${pgpassword}';"
echo $command | docker exec -i lemmy-postgres-1 psql -U lemmy