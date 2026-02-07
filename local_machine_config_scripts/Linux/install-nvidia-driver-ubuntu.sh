sudo apt update && sudo apt upgrade -y
# sudo apt update && sudo apt install -y libnvidia-decode libnvidia-encode
# sudo apt-get remove --purge '^nvidia-.*'
# sudo apt autoremove
# sudo apt install ubuntu-drivers-common -y
sudo reboot
sudo apt install pkg-config libglvnd-dev dkms build-essential libegl-dev libegl1 libgl-dev libgl1 libgles-dev libgles1 libglvnd-core-dev libglx-dev libopengl-dev gcc make -y
sudo add-apt-repository ppa:graphics-drivers/ppa
# sudo apt update
sudo apt install nvidia-driver-580 -y

sudo reboot

#validate nvidia driver installation
nvidia-smi

#install jellyfin
curl https://repo.jellyfin.org/install-debuntu.sh | sudo bash
#install nvidia ffmpeg dependencies for hardware acceleration
sudo apt update && sudo apt install -y jellyfin-ffmpeg7