#!/bin/sh
echo "Checking for Updates to system before we begin.";
sleep 1.5;
yum update -y;
echo "Installing pre-requisits";
sleep 1;
yum install -y yum-utils device-mapper-persistent-data lvm2;
echo "Adding Docker Repo to system";
sleep 1;
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo;
echo "Repo configured, installing Docker";
sleep 1;
yum install -y docker-ce.x86_64;
echo "Docker installed, enabling and starting services";
systemctl start docker;
systemctl enable docker;
echo "Gathering readout information";
systemctl status docker 0;
