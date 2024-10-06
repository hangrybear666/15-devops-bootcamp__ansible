#!/bin/bash


python_location=$(which python3)
pip_version=$(python3 -m pip -V)
pip_version_substr=${pip_version:0:3}
if [ ! -z $python_location ]
  then
    echo "Python located in $python_location"
  else
    echo "No Python3 installation found. Exiting."
    exit 1
fi

if [ $pip_version_substr == "pip" ]
  then
    echo "pip version: $pip_version"
  else
    echo $pip_version_substr
    echo "Pip is not installed. Exiting."
    exit 1
fi

python3 -m pip install ansible
echo "" && echo "##################################"
echo "Ansible installed under $(which ansible)"
echo "Ansible version:"
ansible --version
