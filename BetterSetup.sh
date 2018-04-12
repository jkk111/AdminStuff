#!/bin/bash
if [[ $EUID != 0 ]]; then
  sudo "$0"
  exit
fi

# Recurring Bug, fails to apt update because of this repo
sed -i '/deb cdrom/s/^/#/g' /etc/apt/sources.list

apt update
apt -q -y install curl
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt -q -y install nodejs

# Neat little npm feature, can install from a git repo
npm install -g jkk111/secret-manager

# Get The User Name For Later Config
# https://stackoverflow.com/questions/1629605/getting-user-inside-shell-script-when-running-with-sudo
user=$SUDO_USER

# Get Credentials With A bash script so we can setup without additional prompts
. SetupCreds.sh

mkdir -p /app/socket
mkdir -p /app/ssl
mkdir -p /app/ca

chown -R 600 /app/ca
chmod -R 600 /app/ssl
chown -R root:root /app/ssl
chown -R root:root /app/ca

sudo apt update
sudo apt install curl git

export DEBIAN_FRONTEND="noninteractive"
apt-get -q -y install nodejs nginx mysql-server openssh-server openssl

mysqladmin -uroot password $mysql_password

git clone https://github.com/jkk111/ApplicationManager /app/manager
