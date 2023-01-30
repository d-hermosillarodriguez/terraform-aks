#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y 
sudo apt-add-repository -y ppa:ansible/ansible
add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install ansible -y
sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
ansible-playbook -i /tmp/inventory.txt /tmp/playbook.yml --extra-vars 'ansible_become_pass=Q1w2e3r4t5y6u7$'