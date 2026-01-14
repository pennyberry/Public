#https://support.hytale.com/hc/en-us/articles/45326769420827-Hytale-Server-Manual
sudo apt install openjdk-25-jre -y
sudo apt install unzip -y
java --version

wget https://downloader.hytale.com/hytale-downloader.zip -O /tmp/hytale-downloader.zip
sudo unzip /tmp/hytale-downloader.zip -d /opt/hytale-installer
cd /opt/hytale-installer/

sudo ./hytale-downloader-linux-amd64 -download-path game.zip
#you'll be prompted to login

sudo unzip /opt/hytale-installer/game.zip -d /opt/hytale-server
sudo rm ./game.zip
cd /opt/hytale-server/

#firewall rule
sudo ufw allow 5520/udp

#authenticate with device code flow
OAUTH=$(curl -X POST "https://oauth.accounts.hytale.com/oauth2/device/auth" -H "Content-Type: application/x-www-form-urlencoded" -d "client_id=hytale-server" -d "scope=openid offline auth:server" | jq . -r)
DEVICE_CODE=$(echo $OAUTH | jq -r .device_code)
USER_CODE=$(echo $OAUTH | jq -r .user_code)
VERIFICATION_URI=$(echo $OAUTH | jq -r .verification_uri)
echo "Go to $VERIFICATION_URI and enter code: $USER_CODE"

ACCESS_TOKEN=$(curl -X POST "https://oauth.accounts.hytale.com/oauth2/token" -H "Content-Type: application/x-www-form-urlencoded" -d "client_id=hytale-server" -d "grant_type=urn:ietf:params:oauth:grant-type:device_code" -d "device_code=$DEVICE_CODE" | jq -r .access_token)
UUID=$(curl -X GET "https://account-data.hytale.com/my-account/get-profiles" -H "Authorization: Bearer $ACCESS_TOKEN" | jq .profiles[0].uuid -r)
GAME_SESSION=$(curl -X POST "https://sessions.hytale.com/game-session/new" -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" -d '{"uuid":"'$UUID'"}' | jq . -r)
SESSION_TOKEN=$(echo $GAME_SESSION | jq -r .sessionToken)
IDENTITY_TOKEN=$(echo $GAME_SESSION | jq -r .identityToken)

#create environment file for service
sudo touch /opt/hytale-server/environment
sudo tee /opt/hytale-server/environment > /dev/null <<EOF
SESSION_TOKEN=$SESSION_TOKEN
IDENTITY_TOKEN=$IDENTITY_TOKEN
EOF

#create a systemd service file
sudo tee /etc/systemd/system/hytale.service > /dev/null <<'EOF'
[Unit]
Description=Hytale Server
After=network.target

[Service]
EnvironmentFile=/opt/hytale-server/environment
Type=simple
User=root
WorkingDirectory=/opt/hytale-server/Server
ExecStart=/usr/bin/java -jar /opt/hytale-server/Server/HytaleServer.jar --session-token ${SESSION_TOKEN} --identity-token ${IDENTITY_TOKEN} --assets /opt/hytale-server/Assets.zip
Restart=always
RestartSec=10
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF

#enable and start service
sudo systemctl daemon-reload
sudo systemctl enable hytale
sudo systemctl start hytale

#check status
sudo systemctl status hytale

#default port is 5520
# launch hytale client, go to servers, add server <ip>:5520
