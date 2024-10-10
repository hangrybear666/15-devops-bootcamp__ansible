# 15-devops-bootcamp__ansible
coming up

<b><u>The course examples are:</u></b>
1. Provision 1-n Linode/EC2 Instances /w terraform & use ansible to create linux service-user, install node and npm, then deploy and start a node application
2. Provision 1-n Linode/EC2 Instances /w terraform & use ansible to install java and deploy nexus artifact repository

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

### 5. Install AWS CLI on your development machine

Follow the steps described in https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

## Usage (course examples)

<details closed>
<summary><b>1. Provision 1-n Linode/EC2 Instances /w terraform & use ansible to create linux service-user, install node and npm, then deploy and start a node application</b></summary>

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

#### c. Change remote ips and specific configuration values for your workspace

- Add your ip addresses to `hosts` file and the `linode1.yaml` file in `host_vars/` folder respectively
- Change private key path `ansible_ssh_private_key_file` in `group_vars/all.yaml`
- Replace the `node_pkg_location` variable in `01-linode-deploy-node-app/group_vars/all.yaml`

#### d. Run ansible playbook with different host targets, depending on your setup

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
<summary><b>2. Provision 1-n Linode/EC2 Instances /w terraform & use ansible to install java and deploy nexus artifact repository</b></summary>

#### a. Create 1-n Linode VPS Servers by following the bonus project 2) in the terraform repo

#### b. Change remote ips and specific configuration values for your workspace

- Add your ip addresses to `hosts` file and the `linode1.yaml` file in `host_vars/` folder respectively
- Change private key path `ansible_ssh_private_key_file` in `group_vars/all.yaml`

#### c. Run ansible playbook with different host targets, depending on your setup

```bash
cd 02-linode-deploy-nexus-artifact-repo/
ansible-playbook site.yaml -e "variable_host=linode*"
```

#### d. Navigate to your Remote Hosts Public IP on port 8081 to check availability

*Note:* Your remote firewall must have port 8081 open for ingress
</details>

-----

<details closed>
<summary><b>3. </b></summary>

#### a. Create 1-n EC2 Instances  by following the demo project 2) in the terraform repo

#### b. Change remote ips and specific configuration values for your workspace

- Add your ip addresses to `hosts` file and the `ec2_instance1.yaml` file in `host_vars/` folder respectively
- Change private key path `ansible_ssh_private_key_file` in `group_vars/all.yaml`

#### c. Build and Push java application Image to AWS Elastic Container Registry (ECR)

```bash
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 010928217051.dkr.ecr.eu-central-1.amazonaws.com
docker build -t java-app:2.3 java-app/.
docker tag java-app:2.3 010928217051.dkr.ecr.eu-central-1.amazonaws.com/ansible-imgs:java-app-2.3
docker push 010928217051.dkr.ecr.eu-central-1.amazonaws.com/ansible-imgs:java-app-2.3
```

#### a. Create `.env` file in `03-ec2-deploy-docker-compose/roles/build-and-push-to-ecr/files/java-app/` folder by running the following script, generating random passwords via openssl for you.

```bash
cd scripts
./create-exercise-env-vars.sh
```

#### d. 

Change const HOST = "3.79.46.109"; `03-ec2-deploy-docker-compose/roles/build-and-push-to-ecr/files/java-app/src/main/resources/static/index.html`

#### d. Run ansible playbook with different host targets, depending on your setup

</details>

-----

