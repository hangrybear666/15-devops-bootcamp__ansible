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

#### b. Add remote VPS address to .ssh/known_hosts to avoid Host Key Checking prompt during ansible playbook execution

```bash
# for each of your linodes
ssh-keyscan -H 3.xxx.xxx.247 >> ~/.ssh/known_hosts
```

#### c.


```bash
cd 01-linode-deploy-node-app/

```

</details>

-----

<details closed>
<summary><b>2. </b></summary>


</details>

-----

