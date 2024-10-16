# 15-devops-bootcamp__ansible
Terraform provisioning & Ansible roles to automate installation, config & deployment on remote instances. Includes dynamic inventory, automatic Ansible provisioning, and a Jenkins CI/CD pipeline integration.

<b><u>The course examples are:</u></b>
1. Provision 1-n Linode/EC2 Instances /w terraform & manually start ansible to create linux service-user, install node and npm, then deploy and start a node application
2. Provision 1-n Linode/EC2 Instances /w terraform & manually start ansible to install java and deploy nexus artifact repository
3. Provision 1 Linode/EC2 Instance /w terraform & manually start ansible to run a fullstack docker compose application /w AWS ECR image
4. Provision 1 EC2 Instance /w terraform & <b>automatically</b> start ansible to run a fullstack docker compose application /w AWS ECR image
5. Provision 1 EC2 Instance /w terraform & manually start ansible with <b>dynamic inventory</b> to run a fullstack docker compose application /w AWS ECR image
6. Provision AWS EKS cluster via eksctl & manually start ansible to automatically provide a basic kubernetes deployment
7. Jenkins CI/CD integration to setup an EC2 ansible control node & then run ansible playbook to run a fullstack docker compose application /w AWS ECR image
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
<summary><b>1. Provision 1-n Linode/EC2 Instances /w terraform & manually start ansible to create linux service-user, install node and npm, then deploy and start a node application</b></summary>

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

<u>The following roles are included:</u>

- create-linux-user
- deploy-node-app
- install-acl-for-non-root-users
- install-node-npm

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
<summary><b>2. Provision 1-n Linode/EC2 Instances /w terraform & manually start ansible to install java and deploy nexus artifact repository</b></summary>

#### a. Create 1-n Linode VPS Servers by following the bonus project 2) in the terraform repo

#### b. Change remote ips and specific configuration values for your workspace

- Add your ip addresses to `hosts` file and the `linode1.yaml` file in `host_vars/` folder respectively
- Change private key path `ansible_ssh_private_key_file` in `group_vars/all.yaml`

#### c. Run ansible playbook with different host targets, depending on your setup

<u>The following roles are included:</u>

- check-nexus-availability
- create-permit-nexus-user
- download-untar-nexus
- install-legacy-java
- start-nexus-binary

```bash
cd 02-linode-deploy-nexus-artifact-repo/
ansible-playbook site.yaml -e "variable_host=linode*"
```

#### d. Navigate to your Remote Hosts Public IP on port 8081 to check availability

*Note:* Your remote firewall must have port 8081 open for ingress
</details>

-----

<details closed>
<summary><b>3. Provision 1 Linode/EC2 Instance /w terraform & manually start ansible to run a fullstack docker compose application /w AWS ECR image</b></summary>

#### a. Create 1 EC2 Instance by following the demo project 2) in the terraform repo

https://github.com/hangrybear666/12-devops-bootcamp__terraform

*Limitation:* Since only one image with one remote address is created in the build step, this playbook currently only supports one instance.
We would have to build a separate Image for each instance and change the role in `15-devops-bootcamp__ansible/03-ec2-deploy-docker-compose/roles/build-and-push-to-ecr/tasks/main.yaml`

#### b. Change remote ip and specific configuration values for your workspace

- Add your ip address `ec2_instance1.yaml` file in `host_vars/`
- Change private key path `ansible_ssh_private_key_file` in `group_vars/all.yaml`
- Add `region: YOUR_REGION` and `ecr_repo_name: YOUR_REPO_NAME` (just name without URL) to `group_vars/all.yaml` to overwrite the build-and-push-to-ecr role's vars.
- Overwrite `build_file_path` in `group_vars/all.yaml` to the absolute filepath in your repository for build-and-push-to-ecr role's files folder

#### c. Create `.env` file in `03-ec2-deploy-docker-compose/roles/build-and-push-to-ecr/files/java-app/` folder by running the following script, generating random passwords via openssl for you.

```bash
# required only once for all demo projects
cd scripts
./create-exercise-env-vars.sh
```

<b>Test your java-mysql-phpmyadmin stack locally</b>

```bash
cd 03-ec2-deploy-docker-compose/roles/build-and-push-to-ecr/files/java-app/
VERSION_TAG=0.9 \
docker compose -f docker-compose-local.yaml up
```

#### d. Run ansible playbook

<u>The following roles are included:</u>
- aws-docker-login-ecr
- build-and-push-to-ecr
- create-permit-docker-user
- install-docker-and-compose
- install-pip-boto3
- install-acl-for-non-root-users
- copy-and-start-docker-compose

```bash
ansible-playbook site.yaml -e java_app_version="1.8"
```

</details>

-----

<details closed>
<summary><b>4. Provision 1 EC2 Instance /w terraform & <b>automatically</b> start ansible to run a fullstack docker compose application /w AWS ECR image</b></summary>

#### a. Change specific configuration values for your workspace

- Add `region: YOUR_REGION` and `ecr_repo_name: YOUR_REPO_NAME` (just name without URL) to `group_vars/all.yaml` to overwrite the build-and-push-to-ecr role's vars.
- Overwrite `build_file_path` in `group_vars/all.yaml` to the absolute filepath in your repository for build-and-push-to-ecr role's files folder

#### b. Create `.env` file in `04-ec2-deploy-docker-compose-from-terraform/roles/build-and-push-to-ecr/files/java-app/` folder by running the following script, generating random passwords via openssl for you.

```bash
# required only once for all demo projects
cd scripts
./create-exercise-env-vars.sh
```

<b>Test your java-mysql-phpmyadmin stack locally</b>

```bash
docker volume rm mysql-data-dir
cd 04-ec2-deploy-docker-compose-from-terraform/roles/build-and-push-to-ecr/files/java-app/
VERSION_TAG=0.7 \
docker compose -f docker-compose-local.yaml up
```

#### c. The playbook is executed automatically by terraform once the instance has exposed a public IP.

<u>The following roles are included:</u>
- aws-docker-login-ecr
- build-and-push-to-ecr
- create-permit-docker-user
- install-docker-and-compose
- install-pip-boto3
- install-acl-for-non-root-users
- copy-and-start-docker-compose

#### d. Create 1 EC2 Instance by following the demo project 5) in the terraform repo triggering ansible execution via provisioner

https://github.com/hangrybear666/12-devops-bootcamp__terraform

</details>

-----

<details closed>
<summary><b>5. Provision 1 EC2 Instance /w terraform & manually start ansible with <b>dynamic inventory</b> to run a fullstack docker compose application /w AWS ECR image</b></summary>

#### a. Create 1 EC2 Instance by following the demo project 2) in the terraform repo

*Limitation:* Since only one image with one remote address is created in the build step, this playbook currently only supports one instance.
We would have to build a separate Image for each instance and change the role in `15-devops-bootcamp__ansible/05-ec2-deploy-docker-compose-dynamicInventory/roles/build-and-push-to-ecr/tasks/main.yaml`

https://github.com/hangrybear666/12-devops-bootcamp__terraform

#### b. Change specific configuration values for your workspace

- Change private key path `ansible_ssh_private_key_file` in `group_vars/all.yaml`
- Add `region: YOUR_REGION` and `ecr_repo_name: YOUR_REPO_NAME` (just name without URL) to `group_vars/all.yaml` to overwrite the build-and-push-to-ecr role's vars.
- Overwrite `build_file_path` in `group_vars/all.yaml` to the absolute filepath in your repository for build-and-push-to-ecr role's files folder

#### c. Create `.env` file in `05-ec2-deploy-docker-compose-dynamicInventory/roles/build-and-push-to-ecr/files/java-app/` folder by running the following script, generating random passwords via openssl for you.

```bash
# required only once for all demo projects
cd scripts
./create-exercise-env-vars.sh
```

<b>Test your java-mysql-phpmyadmin stack locally</b>

```bash
docker volume rm mysql-data-dir
cd 05-ec2-deploy-docker-compose-dynamicInventory/roles/build-and-push-to-ecr/files/java-app/
VERSION_TAG=0.8 \
docker compose -f docker-compose-local.yaml up
```

#### d. Run ansible playbook dynamically querying aws for ec2 instance connection details

<u>The following roles are included:</u>
- install-aws-plugin-dependencies
- aws-docker-login-ecr
- build-and-push-to-ecr
- create-permit-docker-user
- install-docker-and-compose
- install-pip-boto3
- install-acl-for-non-root-users
- copy-and-start-docker-compose

```bash
ansible-playbook site.yaml -e java_app_version="1.9"
```

</details>

-----

<details closed>
<summary><b>6. Provision AWS EKS cluster via eksctl & manually start ansible to automatically provide a basic kubernetes deployment</b></summary>

#### a. Create AWS EKS cluster by following project 4 in aws k8s repo and install required dependencies locally

https://github.com/hangrybear666/11-devops-bootcamp__kubernetes_aws_eks

#### b. Change specific configuration values for your workspace

- *Note:* Change kubeconfig filepath in aws eks command to your own.
```bash
aws eks update-kubeconfig --name aws-eksctl-cluster --region eu-central-1 --kubeconfig /home/admin/git/15-devops-bootcamp__ansible/06-aws-eks-deploy-to-kubernetes/kube.config
```
- Change private key path `ansible_ssh_private_key_file` in `group_vars/all.yaml`
- Replace `manifest_file_path` in `host_vars/localhost.yaml` to the absolute path where the `nginx-deployment.yaml` file is situated in your workspace

#### c. Run kubectl commands to ensure cluster & kube.config file has been setup correctly

```bash
cd 06-aws-eks-deploy-to-kubernetes/
export KUBECONFIG=kube.config
kubectl get nodes
kubectl get all -n kube-system
```

#### d. Run ansible playbook dynamically querying aws for ec2 instance connection details

<u>The following roles are included:</u>

- install-k8s-python-dependencies
- create-namespace
- deploy-single-k8s-manifest

- *Note:* Change kubeconfig filepath in aws eks command to your own.
```bash
cd 06-aws-eks-deploy-to-kubernetes/
export K8S_AUTH_KUBECONFIG="/home/admin/git/15-devops-bootcamp__ansible/06-aws-eks-deploy-to-kubernetes/kube.config"
ansible-playbook site.yaml
```

</details>

-----

<details closed>
<summary><b>7. Jenkins CI/CD integration to setup an EC2 ansible control node & then run ansible playbook to run a fullstack docker compose application /w AWS ECR image</b></summary>

#### a. Create Jenkins Server by following bonus project 1 in terraform repo

<u>Bonus Project 1:</u>
https://github.com/hangrybear666/12-devops-bootcamp__terraform

#### b. Create Linode Instance for Ansible Control Node by following bonus project 2 in terraform repo

*Note:* Save the ssh private key for creating jenkins credentials later.

<u>Bonus Project 2:</u>
https://github.com/hangrybear666/12-devops-bootcamp__terraform


#### c. Create 1 EC2 Instance and whitelist your control node IP for java app deployment via ansible playbook by following demo project 2 in terraform repo

<b><u>IMPORTANT:</u></b> Whitelist your control node ip by adding it to `my_ips` in `terraform-02-ec2-modularized/terraform.tfvars`

*Note:* Save the ssh private key for creating jenkins credentials later.

<u>Demo Project 2:</u>
https://github.com/hangrybear666/12-devops-bootcamp__terraform

*Limitation:* Since only one image with one remote address is created in the build step, this playbook currently only supports one instance.
We would have to build a separate Image for each instance and change the role in `15-devops-bootcamp__ansible/07-jenkins-ansible-integration/roles/build-and-push-to-ecr/tasks/main.yaml`


#### d. Install required ansible dependencies on Linode ansible control node via ssh and configure via scp

*NOTE:* Replace ssh target ip with your own.

- Install Ansible and python dependencies via script
- Install AWS CLI and dependencies via same script
- Copy AWS Config and Credentials via scp

```bash
cd scripts/
ssh -i ~/.ssh/id_ed25519 root@172.104.237.64 'bash -s' < setup-ansible-control-node.sh
scp -r ~/.aws/. root@172.104.237.64:/root/.aws/
```

#### e. Create `.env` file in `07-jenkins-ansible-integration/roles/build-and-push-to-ecr/files/java-app/` folder by running the following script, generating random passwords via openssl for you.

```bash
# required only once for all demo projects
cd scripts
./create-exercise-env-vars.sh
```

#### f. Change specific configuration values for your workspace

- Change environment variable `ANSIBLE_CONTROL_NODE_IP` in `Jenkinsfile` to contain your control node IP address.

#### g. Configure Jenkins Pipeline & Server

**Create Secrets**
- Create Username:Password with the id `git-creds` with either your username or jenkins and an API Token as password
- Create SSH Username:Private Key with the id `control-node-pk` and provide the private key used for Linode Server Setup. User is `root`
- Create SSH Username:Private Key with the id `ec2-targets-pk` and provide the private key used for EC2 Instances Setup. User is `admin`
- Create Secret File with the id `ansible-java-app-env` and copy the outout of step 3) into it (or run $(cat 07-jenkins-ansible-integration/roles/build-and-push-to-ecr/files/java-app/.env))

**Create Pipeline**
- Create a new multibranch pipeline named `15_ansible` with GIT Token credentials and add https://github.com/hangrybear666/15-devops-bootcamp__ansible.git
- Jenkinsfile in pipeline is located under `07-jenkins-ansible-integration/Jenkinsfile`

**Configure Jenkins Plugins**
- Install SSH Agent Plugin under Manage Jenkins -> Plugins -> Available Plugins

#### h. Ansible Playbook being executed by control node

<u>The following roles are included:</u>
- install-aws-plugin-dependencies
- aws-docker-login-ecr
- build-and-push-to-ecr
- create-permit-docker-user
- install-docker-and-compose
- install-pip-boto3
- install-acl-for-non-root-users
- copy-and-start-docker-compose

</details>

-----
