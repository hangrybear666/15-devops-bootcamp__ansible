#!/bin/bash


python_location=$(which python3)
pip_version=$(python3 -m pip -V)
pip_version_substr=${pip_version:0:3}
if [ ! -z $python_location ]
  then
    echo "Python located in $python_location"
  else
    sudo apt-get update && sudo apt-get install -y python3
fi

if [ $pip_version_substr == "pip" ]
  then
    echo "pip version: $pip_version"
  else
    echo $pip_version_substr
    sudo apt-get update && sudo apt-get install -y python3-pip
fi

sudo apt-get update && sudo apt-get install -y python3-venv
sudo apt-get install -y python3-boto3
sudo python3 -m venv .venv
source /root/.venv/bin/activate
pip install ansible

echo "" && echo "##################################"
echo "Ansible installed under $(which ansible)"
echo "Ansible version:"
ansible --version
