#!/bin/bash
if [[ $EUID != 0 ]]; then
  sudo "$0"
  exit
fi

# Get The User Name For Later Config
# https://stackoverflow.com/questions/1629605/getting-user-inside-shell-script-when-running-with-sudo
user="$SUDO_USER"

# Recurring Bug, fails to apt update because of this repo
sed -i '/deb cdrom/s/^/#/g' /etc/apt/sources.list

apt update
apt -q -y install curl
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt -q -y install nodejs

# So Here We Get A Few Issues Because We're Running As Root
# Broken Permissions on npm for example

# chmod -R 700 ~/.npm
# chown -R "$user:$user" ~/.npm

# Neat little npm feature, can install from a git repo
# su - $user -c "npm install -g jkk111/secret-manager"
# Never Mind More hassle than its worth

# git clone https://github.com/jkk11/secret-manager

sudo chown $user:$user /usr/lib/node_modules
sudo npm install -g @jkk111/secret-manager

# Get Credentials With A bash script so we can setup without additional prompts
. SetupCreds.sh

mkdir -p /app/socket
mkdir -p /app/ssl
mkdir -p /app/ca

chown -R 600 /app/ca
chmod -R 600 /app/ssl
chown -R root:root /app/ssl
chown -R root:root /app/ca
chown -R root:root /usr/lib/node_modules # Makes sense to have this be root only writable, I think

sudo apt update
sudo apt install curl git

export DEBIAN_FRONTEND="noninteractive"
apt-get -q -y install nodejs nginx mysql-server openssh-server openssl

mysqladmin -u root password $mysql_password

git clone https://github.com/jkk111/ApplicationManager /app/manager

sed -i 's/PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd
