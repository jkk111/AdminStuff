#!/bin/bash
if [[ $EUID != 0 ]]; then
  sudo "$0"
  exit
fi

# Get Credentials With A bash script so we can setup without additional prompts
. SetupCreds.sh

# Recurring Bug, fails to apt update because of this repo
sed -i '/deb cdrom/s/^/#/g' /etc/apt/sources.list

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

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get -q -y install nodejs nginx mysql-server openssh-server openssl

mysqladmin -uroot password $mysql_password

git clone https://github.com/jkk111/ApplicationManager /app/manager
