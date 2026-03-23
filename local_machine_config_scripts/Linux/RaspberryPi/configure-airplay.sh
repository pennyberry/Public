#this was tested on a raspberry pi 4 with a usb to 3.5mm audio adapter
# search this UGREEN USB to 3.5mm Jack Audio Adapter Sound Card Support Mic TRRS Headphone DAC 24bit 96kHz Nylon Braided USB to Aux Jack Compatible with Windows Mac Linux PC PS5 PS4 Switch 2 Speaker, 9.8 Inch 

sudo apt update

sudo apt upgrade -y

curl -sSL https://raw.githubusercontent.com/Techposts/RaspberryPi-AirPlay-Installer/main/RaspberryPi-AirPlay-Installer-Scripts/pre_check_airplay_on_pi.sh | bash

sudo apt-get install libplist-utils

curl -sSL https://raw.githubusercontent.com/Techposts/RaspberryPi-AirPlay-Installer/main/RaspberryPi-AirPlay-Installer-Scripts/install_airplay_v3.sh | bash