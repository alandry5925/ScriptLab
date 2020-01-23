#!/bin/sh
#Script for Installing and Deploying Ansible w/ AWX
echo "Adding rules for Firewalld";
sleep 1;
systemctl enable firewalld;
systemctl start firewalld;
firewall-cmd --add-service=http --permanent;firewall-cmd --add-service=https --permanent;
systemctl restart firewalld;
tput setaf 3;echo "Putting SElinux in Permissive Mode"; tput setaf 7;
sleep 1;
setenforce 0;
#Below omitted line causes the system to disable SElinux enforcement completely. Uncomment at will.
#sed -i 's|SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config;
yum -y install epel-release;
yum install -y git gcc gcc-c++ lvm2 bzip2 gettext nodejs yum-utils device-mapper-persistent-data python-pip python36 ansible.noarch;
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo;
yum -y install docker
systemctl start docker && systemctl enable docker;
tput setaf 1; echo "Attempting PIP install of docker Python, if setup fails past this point PROCEED MANUALLY"; tput setaf 7;
pip3 install docker-compose;
sleep 1;
echo "Installing PIP version of Selinux"
pip3 install selinux;
sleep 1;
git clone --depth 50 https://github.com/ansible/awx.git;
cd awx/installer/;
echo "Changing Interpreter to PY3";
sed -i 's|/usr/bin/env python|/usr/bin/python3|g' /root/awx/installer/inventory;
ansible-playbook -i inventory install.yml;
tput setaf 2; echo "Install complete, access your AWX instance using a web browser pointed at this HOST"; tput setaf 7;
sleep 2;
