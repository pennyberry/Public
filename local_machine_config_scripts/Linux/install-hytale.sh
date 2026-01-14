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

sudo ufw allow 5520/udp

#server jar should be in /opt/hytale-server/Server/HytaleServer.jar
sudo java -jar /opt/hytale-server/Server/HytaleServer.jar --assets /opt/hytale-server/Assets.zip --bind 0.0.0.0:5520
#you'll be prompted to login


#inside the jvm console type:
/auth login device

#default port is 5520
# launch hytale client, go to servers, add server <ip>:5520/auth