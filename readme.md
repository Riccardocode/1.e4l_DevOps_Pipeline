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
Download gitlab-runner and make it available locally for the virtual machines
```bash
curl -L --output ~/1.e4l_DevOps_Pipeline/data/installations/gitlab-runner_17.5.3-1_amd64.deb https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb
```
Download docker-ce-cli
```bash
wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce-cli_19.03.15~3-0~ubuntu-xenial_amd64.deb -P ~/1.e4l_DevOps_Pipeline/data/installations
```
Download containerd.io
```bash
wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/containerd.io_1.3.7-1_amd64.deb -P ~/1.e4l_DevOps_Pipeline/data/installations
```

Download the docker-composer
```bash
wget https://github.com/docker/compose/releases/download/1.23.2/docker-compose-linux-x86_64 -P ~/1.e4l_DevOps_Pipeline/data/installations

chmod +x ~/1.e4l_DevOps_Pipeline/data/installations/docker-compose-1.23.2

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
~/1.e4l_DevOps_Pipeline/Scripts/setup-repository-backend.sh
```


### 5. Setup the repository for frontend:
```bash
~/1.e4l_DevOps_Pipeline/Scripts/setup-repository-frontend.sh
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

## Note: Readme to be reviewed from this point.

### 9. start product
After the staging phase of the pipeline is done 
Go Inside stage vm
```bash
vagrant ssh
``` 
make sure the product has been build and it is present, so check the presence of the file e4l-server.jar
```bash
ls ~/stage-backend/build/libs
```
e4l-server.jar should be shown as result of the previous command.

#### Start the database
```bash
cd ~/stage-backend
sudo docker pull mariadb:10.4.7
sudo docker-compose -f ./docker-compose.db.yml up -d
```
#### Start the backend
```bash
cd ~/stage-backend
#build the docker img
sudo docker build -t lu.uni.e4l.platform.backend.dev:rc .  
#start the img
sudo docker-compose -f ./docker-compose.backend.pre-prod.yml up -d 
```

#### Start the frontend
```bash
cd ~/stage-frontend
#pull nginx image
sudo docker pull nginx:1.13.5
#build docker img
sudo docker build -t lu.uni.e4l.platform.frontend.dev:rc ./web/.
#run the img
sudo docker-compose -f ./docker-compose.frontend.pre-prod.yml up -d 
```

#### Change permission to e4l-mysql  e4l-news folders
```bash
cd ~/
sudo chmod 777 e4l-mysql  e4l-news
```