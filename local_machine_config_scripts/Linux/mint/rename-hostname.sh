read -rsp $'Enter your new hostname \n' new_hostname
hostnamectl set-hostname $new_hostname