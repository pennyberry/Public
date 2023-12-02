source env.vars.env
sudo apt install certbot
now=$(date +'%m-%d-%Y--%H-%M')
domain=${domainname}
logdir=/var/log/${domain}
logname="${now}.log"
log="${logdir}/${logname}"
sudo mkdir ${logdir}
sudo touch ${log}
sudo chmod +x ${log}
sudo chown joe:joe ${log}
sudo chmod 755 ${logdir}
sudo chmod 644 ${log}
sudo certbot certonly --manual --preferred-challenges http -d ${domain} >> ${log} 2>&1
sudo cat ${log}