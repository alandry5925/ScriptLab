#!/bin/sh
yum install -y python36;
pip3 install boto3;
mkdir -pv ~/.aws/;
cd ~/.aws/;
touch credentials;
echo [default] >> credentials && echo aws_access_key_id = YOUR-ACCESS-KEY-HERE >> credentials && echo aws_secret_access_key = YOUR-SECRET-ACCESS-KEY-HERE >> credentials;
touch config;
echo [default] >> config && echo region = us-west-1 >> config;
cd ~ && wget https://raw.githubusercontent.com/alandry5925/ScriptLab/master/boto_test.py;
echo Configure your IAM AWS Access keys in ~/.aws/credentials to enable connectivity.;
echo Run boto_test.py to get a returned sample output of able-to-reach s3 bucket names;
sleep 2;
echo End of script;
