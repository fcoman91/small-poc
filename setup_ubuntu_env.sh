#!/bin/bash

# Install prerequisite tools
sudo apt update

# Install Virtualbox
sudo echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib" /etc/apt/sources.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt update
sudo apt install -y virtualbox-6.1
sudo apt --fix-broken install -y
sudo apt install -y virtualbox virtualbox-ext-pack

# Install Ansible
sudo apt install -y software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# Instal Vgrant
version="2.2.14"
wget https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_x86_64.deb
sudo dpkg -i vagrant_${version}_x86_64.deb
sudo apt install -y vagrant

# Install Jenkins
sudo apt install -y openjdk-8-jdk
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install -y jenkins
