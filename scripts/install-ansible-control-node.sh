#!/bin/bash


python_location=$(which python3)
pip_version=$(python3 -m pip -V)
if [ ! -z $python_location ]
  then
    echo "Python located in $python_location"
  else
    # install python
    sudo apt-get update && sudo apt-get install -y python3
fi

if [ $pip_version_substr == "pip" ]
  then
    echo "pip version: $pip_version"
  else
    # install pip
    sudo apt-get update && sudo apt-get install -y python3-pip
fi

sudo apt-get update && sudo apt-get install -y python3-venv
# sudo apt-get install -y python3-boto3
sudo python3 -m venv .venv
source /root/.venv/bin/activate
pip install ansible
# dependencies in vertiual env for aws cli integration
pip install boto3
pip install packaging
pip install requests
pip install botocore

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get update && sudo apt-get install -y unzip && unzip awscliv2.zip
sudo ./aws/install
mkdir /root/.aws

echo "" && echo "##################################"
echo "Ansible installed under $(which ansible)"
echo "Ansible version:"
ansible --version

