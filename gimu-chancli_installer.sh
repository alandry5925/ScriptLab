#!/bin/sh
#Author: [Python Script: Gimu] [CentOS Installer Script: alandry5925]
#Date: 02/17/2020
#Title: 4chan CLI browser installer
tput setaf 1; echo Script made for CENTOS 7 Distros!;
tput setaf 6; echo "chancli Author:" 
echo "Gimu (https://github.com/Gimu/chancli)"; tput setaf 7;
sleep 2;
tput setaf 2; echo Installing chancli using GIT; tput setaf 7;
echo Press "[ENTER] to Continue";
tput setaf 4;read prompt;tput setaf 7;
yum install -y git python36;
pip3 install urwid;
cd ~;
git clone https://github.com/Gimu/chancli.git;
echo "alias 4chan='python3 ~/chancli/chancli.py'" >> ~/.bashrc;
echo "Sourcing ~/.bashrc for refresh of aliases";
source /etc/bash.bashrc;
sleep 1;
tput setaf 3; echo "chancli script installed, Alias has been set to '4chan'"; tput setaf 7;
echo "Dependencies Installed: Python3.6 and git";
echo "Installed Python Packges: urwid";
echo "Closing script, enter '4chan' in your shell to launch."
sleep 1;
