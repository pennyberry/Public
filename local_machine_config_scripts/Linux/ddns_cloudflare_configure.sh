#copy this and env-vars.env to /etc/cron.daily/ and make it executable
# cp /home/joe/Public/local_machine_config_scripts/Linux/ddns_cloudflare_configure.sh /etc/cron.daily/
# cp /home/joe/Public/local_machine_config_scripts/Linux/env-vars.env /etc/cron.daily/
#chmod 700 /etc/cron.daily/ddns_cloudflare_configure.sh
#This script will update the Cloudflare DNS record with the current external IP address of the machine it is running on.

# The env-vars.env file should look like this:
# mydomain="joeberry.org"
# myhostname="*"
# CLOUDFLARE_API_KEY="REDACTED"
# CLOUDFLARE_EMAIL="REDACTED"
# ZONE_ID="REDACTED"
# DNS_RECORD_ID="REDACTED"

#!/bin/bash

source env-vars.env

myip=`curl -s "https://api.ipify.org"`

cloudflarednsresult=`curl -s https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID \
-H "Authorization: Bearer ${CLOUDFLARE_API_KEY}"`

cloudflareip=`echo $cloudflarednsresult | jq -r '.result.content'`

if [ "$myip" != "$cloudflareip" ]; then
    update_result=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'"$myhostname.$mydomain"'","content":"'"$myip"'","ttl":1,"proxied":true}')
    
    if echo "$update_result" | jq -e '.success' > /dev/null; then
        echo "DNS record updated successfully."
    else
        echo "Failed to update DNS record."
    fi
else 
    echo "IP address has not changed. No update required."
fi