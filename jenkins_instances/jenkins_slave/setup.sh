#!/bin/bash -e

sudo apt update -y
sudo apt install python3.7 -y
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
sudo apt install software-properties-common -y
sudo apt update -y
sudo apt install python3-pip -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt update -y
sudo apt install ansible -y