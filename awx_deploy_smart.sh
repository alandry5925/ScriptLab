#!/bin/sh
#Script for Installing and Deploying Ansible w/ AWX
#sed -i 's|SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config;
#Package Managers by Distro (DEFINED VARS)
set -e
YUM_PACKAGES="git gcc gcc-c++ lvm2 bzip2 gettext nodejs yum-utils device-mapper-persistent-data python-pip python36 ansible.noarch epel-release"
APT_PACKAGES="firewalld gcc g++ lvm2 selinux-utils nodejs python-pip python3.6 ansible"

if cat /etc/*release | grep ^NAME | grep CentOS; then
   echo "CentOS Detected";
   sleep 3;
   echo "Adding rules for Firewalld";
   sleep 1;
   systemctl enable firewalld;
   systemctl start firewalld;
   firewall-cmd --add-service=http --permanent;firewall-cmd --add-service=https --permanent;
   systemctl restart firewalld;
   echo "Installing packages...";
   yum install -y $YUM_PACKAGES;
   echo "Putting SElinux in Permissive Mode";
   sleep 1;
   setenforce 0;
   yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo;
   yum -y install docker-ce;
   systemctl start docker && systemctl enable docker;
   echo "Attempting PIP install of docker Python, if setup fails past this point proceed manually";
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
   echo "CentOS Installation of AWX complete, Connect using Host IP on Port 80";
   sleep 2;

elif cat /etc/*release | grep ^NAME | grep Ubuntu; then
   echo "Ubuntu Detected";
   sleep 3;
   echo "Installing Packages";
   apt-get install -y $APT_PACKAGES;
   echo "Configuring firewall";
   firewall-cmd --add-service=http --permanent;firewall-cmd --add-service=https --permanent;
   service firewalld --full-restart;
   sleep 1;
   #echo "Putting SELINUX in permissive mode";
   #setenforce 0;
   apt upgrade -y snapd;
   #addgroup --system docker;
   #adduser $USER docker;
   #newgrp docker;
   snap install docker;
   snap connect docker:account-control :account-control;
   snap connect docker:home :home;
   snap disable docker
   snap enable docker
   snap start docker;
   echo "Attempting install of Docker-Python";
   pip3 install docker-compose;
   echo "Installing PIP version of Selinux"
   pip3 install selinux;
   sleep 1;
   git clone --depth 50 https://github.com/ansible/awx.git;
   cd awx/installer/;
   echo "Changing python interpreter for AWX Installer file";
   sed -i 's|/usr/bin/env python|/usr/bin/python3|g' /root/awx/installer/inventory;
   ansible-playbook -i inventory install.yml;
   echo "Ubuntu Installation of AWX complete, Connect using Host IP on Port 80"
   sleep 1;

else
  echo "SYSTEM IS NOT A Script-SUPPORTED DISTRO";
  exit 1;
fi;
