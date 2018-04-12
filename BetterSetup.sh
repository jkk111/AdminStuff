#!/bin/bash
if [[ $EUID != 0 ]]; then
  sudo "$0"
  exit
fi

function password() {
  local need_password=1
  local bad_attempt=0
  local confirm=""

  while [[ $need_password -eq 1 ]]
  do
    if [[ $bad_attempt -eq 1 ]]; then
      echo "Passwords Must Match"
    fi
    echo "Please Enter Password For $1"
    echo -n "Password: "
    read -s password
    echo "$2 ${!2}"

    echo -n "Confirm: "
    read -s confirm
    echo

    if [[ $password = $confirm ]]; then
      need_password=0
    else
      bad_attempt=1
    fi
    eval "${2}=$password"
  done
}

echo "Starting Setup"

echo "First we need to get some credentials"
password MySql mysql_password
password "Secret Manager" secret_password

sed -i '/deb cdrom/s/^/#/g' /etc/apt/sources.list

mkdir -p /app/socket
mkdir -p /app/ssl
mkdir -p /app/ca

chmod -R 666 /app/ssl
chown -R root:root /app/ssl

sudo apt update
sudo apt install curl git

export DEBIAN_FRONTEND="noninteractive"

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get -q -y install nodejs nginx mysql-server openssh-server openssl

mysqladmin -uroot password $mysql_password

git clone https://github.com/jkk111/ApplicationManager /app/managers
