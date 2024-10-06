# 15-devops-bootcamp__ansible
coming up

<b><u>The course examples are:</u></b>
1. Provision Linode VPS /w terraform & use ansible to create linux service-user, install node and npm, then deploy and start a node application
2. Provision Linode VPS /w terraform & use ansible to

<!-- <b><u>The exercise projects are:</u></b> -->

## Setup

### 1. Pull SCM

Pull the repository locally by running
```bash
git clone https://github.com/hangrybear666/15-devops-bootcamp__ansible.git
```
### 2. Install python3 on your development machine

For debian 12 it is already preinstalled.

### 3. Install terraform on your development machine

For debian 12 you can use the following installation script, otherwise follow https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
```bash
cd scripts/ && ./install-terraform.sh
```

### 4. Install ansible on your development machine

```bash
cd scripts/ && ./install-ansible.sh
```
<!--
### 5. Setup environment variables with your credentials

```bash
cd scripts/ && ./setup-env-vars.sh
``` -->

## Usage (course examples)

<details closed>
<summary><b>1. Provision Linode VPS /w terraform & use ansible to create linux service-user, install node and npm, then deploy and start a node application</b></summary>

#### a. Create 1-n Linode VPS Servers by following the bonus project 2) in the terraform repo

https://github.com/hangrybear666/12-devops-bootcamp__terraform.git

#### b. If you want to disable strict host key checking you have two options

<u>Alternative 1:</u>

- Simply leave `host_key_checking = False` in `ansible.cfg`

<u>Alternative 2:</u>

- Comment out  `host_key_checking = False` in `ansible.cfg`
- For each target server run ssh-keyscan to add the targets to your known_hosts
```bash
# for each of your linodes
ssh-keyscan -H 321.xxx.xxx.247 >> ~/.ssh/known_hosts
```

#### c. Change the path to the nodejs deployment file to match your system's file structure

- Replace the `node_pkg_location` variable in `01-linode-deploy-node-app/group_vars/all.yaml`

#### d. Change the ip addresses of your remote hosts in hosts and host_vars

- Add your ip addresses to `hosts` file and the `linode1.yaml` file in `host_vars/` folder respectively

#### e. Run ansible playbook with different host targets, depending on your setup

```bash
cd 01-linode-deploy-node-app/
# to run only on linode1
ansible-playbook -i hosts site.yaml -e "variable_host=linode1"
# to run only on first ec2-instance
ansible-playbook -i hosts site.yaml -e "variable_host=ec2-instance1"
# to run on all ec2-instances
ansible-playbook -i hosts site.yaml -e "variable_host=ec2_instances"
# to run on all linodes use group name
ansible-playbook -i hosts site.yaml -e "variable_host=linodes"
# or use individual names with wildcard
ansible-playbook -i hosts site.yaml -e "variable_host=linode*"
```

</details>

-----

<details closed>
<summary><b>2. </b></summary>


</details>

-----

