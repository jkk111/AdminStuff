#!/bin/bash
if [[ $EUID != 0 ]]; then
  sudo "$0"
  exit
fi

# Wrote this for quicker dev on my firewalled vmware instance on home server
# Not Public Facing, Reset To Snapshot Frequently

echo "Seriously This Is Horrendously Insecure"
echo "Only Run This If You Know What You're Doing!"
read -p "Enter \"I Accept\" To Continue: " acceptance

if [[ $acceptance != "I Accept" ]]; then
  echo "Incorrect Input"
  echo "Exiting"
  exit
fi

echo "Enabling Root SSH"

echo "Enter New Root User Password"
echo "(In Clear Told You it was Dangerous)" 
read -p "Password: " password

apt -q -y install openssh-server
echo "root:$password" | chpasswd
sed -i '/^PermitRootLogin/s/\s/ yes # /g' /etc/ssh/sshd_config
systemctl restart sshd
