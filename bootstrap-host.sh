#!/usr/bin/env bash
echo "-----------------------------------------------------------------------------------"
echo "           CHI (Container Hosting Infrastructure) Bootstrap Host Script"
echo "-----------------------------------------------------------------------------------"
echo "This script will install the necessary software on the host machine to run the CHI"
echo "environment. This script is intended to be run on a fresh Ubuntu 22.04 or 24.04 LTS install."

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root"
  exit
fi

# Check if system is an ubuntu 22.04 LTS or higher
if [ "$(lsb_release -rs)" != "22.04" ] && [ "$(lsb_release -rs)" != "24.04" ]; then
  echo "This script is intended to be run on Ubuntu 22.04 or 24.04 LTS"
  exit
fi

# Update and upgrade the system
apt update && apt upgrade -y
apt install acl git -y

# Install Docker
echo "-----------------------------------------------------------------------------------"
echo "          CHI (Container Hosting Infrastructure) Removing Old Docker Packages"
echo "-----------------------------------------------------------------------------------"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done


# Install Docker
echo "-----------------------------------------------------------------------------------"
echo "          CHI (Container Hosting Infrastructure) Docker Installation"
echo "-----------------------------------------------------------------------------------"
# Add Docker's official GPG key:
sudo apt-get -y update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# loop through array of directories and create directories
echo "-----------------------------------------------------------------------------------"
echo "          CHI (Container Hosting Infrastructure) Directory Creation"
echo "-----------------------------------------------------------------------------------"
CHI_DIRS=("/chi" "/chi/bin" "/chi/svc" "/chi/log" "/chi/tmp")
for dir in "${CHI_DIRS[@]}"; do
    echo "Creating directory: $dir"
    mkdir -pv "$dir"
    echo "Setting permissions on directory: $dir"
    setfacl -R -d -m g:docker:rwx "$dir"
    setfacl -R -m g:docker:rwx "$dir"
done
