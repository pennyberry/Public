#copy this and env-vars.env to /etc/cron.daily/ and make it executable
#chmod 700 /etc/cron.daily/ddns_godaddy_configure.sh
#This script will update the GoDaddy DNS record with the current external IP address of the machine it is running on.
#It will only update the DNS record if the IP address has changed.
#The script will read the GoDaddy API key and domain information from the env-vars.env file.
# Use https://developer.godaddy.com/keys to get your API key

# The env-vars.env file should look like this:
# mydomain="domain.com"
# myhostname="subdomain"
# gdapikey="key:secret"

#this allegedly doesn't work on godaddy's production API, but it works on the test API due to a requirement of 50 domains in the account
#https://www.reddit.com/r/godaddy/comments/1bl0f5r/am_i_the_only_one_who_cant_use_the_api/

#!/bin/bash

source env-vars.env

myip=`curl -s "https://api.ipify.org"`
dnsdata=`curl -s -X GET -H "Authorization: sso-key ${gdapikey}" "https://api.ote-godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}"`
gdip=`echo $dnsdata | cut -d ',' -f 1 | tr -d '"' | cut -d ":" -f 2`
echo "`date '+%Y-%m-%d %H:%M:%S'` - Current External IP is $myip, GoDaddy DNS IP is $gdip"

if [ "$gdip" != "$myip" -a "$myip" != "" ]; then
  echo "IP has changed!! Updating on GoDaddy"
  curl -s -X PUT "https://api.godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}" -H "Authorization: sso-key ${gdapikey}" -H "Content-Type: application/json" -d "[{\"data\": \"${myip}\"}]"
fi