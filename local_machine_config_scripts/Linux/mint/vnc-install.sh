sudo apt install lightdm x11vnc -y
# run this command to validate 
# x11vnc
read -rsp $'Enter the password for the VNC server \n' vnc_password
sudo tee /lib/systemd/system/vnc.service > /dev/null <<EOF
[Unit]
# service description
Description=my local x11vnc kimchi service
# start this service after:
After=display-manager.service network.target syslog.target
[Service]
# the type of the service
Type=simple
# process config
ExecStart=/usr/bin/x11vnc -forever -display :0 -auth guess -passwd $vnc_password
# do this on process stop
ExecStop=/usr/bin/killall x11vnc
# restart when failed
Restart=on-failure
[Install]
# start this service before multi-user target
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable vnc.service
sudo systemctl start vnc.service
sudo systemctl status vnc.service
sudo ufw allow 5900