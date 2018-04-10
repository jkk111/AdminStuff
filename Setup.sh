mkdir -p /app/socket
mkdir -p /app/ssl
chmod -R 666 /app/ssl
chown -R root:root /app/ssl

sudo apt update
sudo apt install curl git

export DEBIAN_FRONTEND="noninteractive"

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt update
apt -q -y install nodejs nginx mysql-server openssh-server

mysqladmin -uroot password

git clone https://github.com/jkk111/ApplicationManager /app/manager

