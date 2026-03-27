pg_restore -U authentik -d authentik -1 /var/lib/postgresql/data/<postgres_backup_file>.dump

#or

psql -U authentik -d authentik < /var/lib/postgresql/data/<sql_backup_file>.sql