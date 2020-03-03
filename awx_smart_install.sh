#!/bin/sh
#Script for Installing and Deploying Ansible w/ AWX
################################
##Author: Austin Landry        #
##Name  : awx_smart_install.sh #
##Date  : 2/4/2020             #
################################
#Package Managers by Distro (DEFINED VARS)
set -e
YUM_PACKAGES="git gcc gcc-c++ lvm2 bzip2 gettext nodejs yum-utils device-mapper-persistent-data python-pip python36 epel-release"
APT_PACKAGES="firewalld gcc g++ lvm2 selinux-utils nodejs python-pip python3-pip python3.6"
tput setaf 6;echo "Welcome to the AWX Smart Deployment script."; tput setaf 7;
tput setaf 5;echo "Supported Distros: RHEL 7 / CENTOS 7 & UBUNTU 18.04"; tput setaf 7;
echo Press "[ENTER] to Continue";
tput setaf 4;read prompt;tput setaf 7;

if cat /etc/*release | grep ^NAME | grep -E -- 'CentOS|Red'; then
   tput setaf 6;echo "CentOS or RHEL Detected";tput setaf 7;
   sleep 3;
   echo "Adding rules for Firewalld";
   sleep 1;
   systemctl enable firewalld;
   systemctl start firewalld;
   firewall-cmd --add-service=http --permanent;firewall-cmd --add-service=https --permanent;
   systemctl restart firewalld;
   tput setaf 3;echo "Installing packages..."; tput setaf 7;
   yum install -y $YUM_PACKAGES;
   tput setaf 1; echo "Installing Ansible Noarch";tput setaf 7;
   yum install -y ansible-2.9.3-1.el7.noarch;
   yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo;
   yum -y install docker-ce;
   systemctl start docker && systemctl enable docker;
   tput setaf 1;echo "Attempting PIP install of docker Python, if setup fails past this point proceed manually";tput setaf 7;
   pip3 install docker-compose;
   sleep 1;
   tput setaf 3;echo "Installing PIP version of Selinux"; tput setaf 7;
   pip3 install selinux;
   sleep 1;
   git clone --depth 50 https://github.com/ansible/awx.git;
   cd ~;
   cd awx/installer/;
   tput setaf 2;echo "Changing Interpreter to PY3";tput setaf 7;
   sed -i 's|/usr/bin/env python|/usr/bin/python3|g' /root/awx/installer/inventory;
   ansible-playbook -i inventory install.yml;
   tput setaf 2;echo "CentOS Installation of AWX complete, Connect using Host IP on Port 80";tput setaf 7;
   sleep 2;

elif cat /etc/*release | grep ^NAME | grep Ubuntu; then
   tput setaf 6;echo "Ubuntu Detected";tput setaf 7;
   sleep 3;
   tput setaf 3;echo "Installing Packages";tput setaf 7;
   apt install software-properties-common;
   apt-add-repository --yes --update ppa:ansible/ansible;
   apt install -y ansible;
   apt-get install -y $APT_PACKAGES;
   tput setaf 3;echo "Configuring firewall";tput setaf 7;
   firewall-cmd --add-service=http --permanent;firewall-cmd --add-service=https --permanent;
   service firewalld reload;
   sleep 1;
   apt install -y docker.io;
   systemctl start docker && systemctl enable docker;
   tput setaf 3;echo "Attempting install of Docker-Python";tput setaf 7;
   pip3 install docker-compose;
   tput setaf 3;echo "Installing PIP version of Selinux"tput setaf 7;
   pip3 install selinux;
   sleep 1;
   git clone --depth 50 https://github.com/ansible/awx.git;
   cd ~;
   cd awx/installer/;
   tput setaf 2;echo "Changing python interpreter for AWX Installer file";tput setaf 7;
   sed -i 's|/usr/bin/env python|/usr/bin/python3|g' /root/awx/installer/inventory;
   ansible-playbook -i inventory install.yml;
   tput setaf 2;echo "Ubuntu Installation of AWX complete, Connect using Host IP on Port 80";tput setaf 7;
   sleep 1;

else
  tput setaf 1;echo "SYSTEM IS NOT A Script-SUPPORTED DISTRO";tput setaf 7;
  exit 1;
fi;
