#check disk / physical volume / logical volume info with
# fdisk -l
# df -h
# pvdisplay    
# lvdisplay

#expand the disk that use Logical Volumes with:
sudo growpart /dev/sda 3
sudo pvresize /dev/sda3
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv

#expand the disk using ext4 partitions:
sudo growpart /dev/sda 1
sudo resize2fs /dev/sda1