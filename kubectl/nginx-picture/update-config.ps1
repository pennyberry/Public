read-host "enter the ip address of the nfs server" -OutVariable nfsServer
Copy-Item ~\gitlocal\Public\kubectl\nginx-picture\config\* "\\$nfsServer\mnt\zfs\nfs\applications\nginx-picture\volumes\config\www\" -Recurse -Force
Copy-Item ~\gitlocal\Public\kubectl\nginx-picture\config\php-local.ini "\\$nfsServer\mnt\zfs\nfs\applications\nginx-picture\volumes\config\php\php-local.ini" -Recurse -Force
kubectl rollout restart deployment/nginx-picture -n default