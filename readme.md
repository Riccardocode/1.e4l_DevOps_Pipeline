# 1.e4l DevOps Pipeline

This repository contains the DevOps pipeline setup and related configurations for the e4l project.

## Getting Started

### Prerequisites

- Ensure you have Git installed. You can check by running:
  ```bash
  git --version
- Ensure you have Virtual box v:7.0 installed 
- Ensure you have ansible installed

## Pipeline
### 1. Clone the Repository
```bash
cd ~/
git clone https://github.com/Riccardocode/1.e4l_DevOps_Pipeline
```
### 2. Check if repository is present in your ~/ directory
```bash
ls
```
You should see all the files componing the repository
Note: before working on the repository, git fetch and git pull to ensure you have the latest version of the code.

### 3. Start integration environment
```bash
cd ~/1.e4l_DevOps_Pipeline/s2-automate-build/integration-server
vagrant up
```
this will start the virtual machine for the integration Environment


### 4. Setup the repository for backend:
```bash 
~/1.e4l_DevOps_Pipeline/s2-automate-build/integration-server/playbook/provision_scripts/setup-repository-backend.sh
```

### 5. Setup the repository for frontend:
```bash
~/1.e4l_DevOps_Pipeline/s2-automate-build/integration-server/playbook/provision_scripts/setup-repository-frontend.sh
```

### 6. Setup the runner inside the CI virtual machine
Open a new terminal
```bash 
cd ~/1.e4l_DevOps_Pipeline/s2-automate-build/integration-server
vagrant ssh
~/provision_scripts/setup-gitlab-runner.sh
```
### 7. Create directory inside the integration VM and change permissions
```bash 
cd /home/vagrant
mkdir artefact-repository
chmod 777 artefact-repository/
```

### 8. Start The Stage Virtual machine
open a new terminal
```bash
cd ~/s3-automate-deploy/stage-vm
vagrant up
```
This command will also set the the runner to move the product into this environment.

When a new commit is pushed, the runner will take the new candidate to the stage environment.