#!/bin/sh
yum install -y python36;
pip3 install boto;
mkdir -pv ~/.aws/;
touch credentials;
echo [default] >> credentials && echo aws_access_key_id = YOUR-ACCESS-KEY-HERE >> credentials && echo aws_secret_access_key = YOUR-SECRET-ACCESS-KEY-HERE;
touch config;
echo [default] >> config && echo region = us-west-1 >> config;

