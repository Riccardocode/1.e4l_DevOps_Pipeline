# 1.e4l DevOps Pipeline

This repository contains the DevOps pipeline setup and related configurations for the e4l project.

## Getting Started

### Prerequisites
This project uses the following software versions
- git version 2.34.1
- ansible 2.10.8
- Virtual box v:7.0 installed 
- Vagrant 2.3.7
Those versions will be installed during the setup project
NOTE: Different versions of this software will be removed.


## Pipeline
### 1. Clone the Repository
```bash
cd ~/
git clone https://github.com/Riccardocode/1.e4l_DevOps_Pipeline
```
Verify if the clone procedure has worked by using the command ls
```bash
ls
```
You should see a folder named 1.e4l_DevOps_Pipeline

### 2. Start the setup
Run the setup script to start the setup process
```bash
# move inside the project directory
cd ~/1.e4l_DevOps_Pipeline
# give execute permission to the script
chmod +x ./Scripts/setup_e4l_pipeline.sh
# Execute the script
./Scripts/setup_e4l_pipeline.sh
```

### 3. Verify your installation
#### 3.1 Verify gitlab installation (Integration Env)
goto http://192.168.56.9/gitlab
Here you should see gitlab login page.
Use the the following credentials
- login: ProjectOwner
- password: projectowner

Once inside you should be able to see the repositories

#### 3.2 Verify Stage Env
goto http://192.168.56.7:8884/
You should see the frontend page of the product

#### 3.3 Verify Production Env
goto http://192.168.56.2:8884/
You should see the frontpage of the product

### 4 Congratulation! you should be set up!
#### 4.1 Trigger pipeline for backend
To commit changes for the backend: 
```bash 
cd ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev
git add .
git commit -m "Explanatory message"
git push
```
Note: the pipeline is triggered when commit/s is/are pushed to the repository.

#### 4.2 Trigger pipeline for frontend
To commit changes for the frontend: 
```bash
cd ~/home/riccardo~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev
git add .
git commit -m "Explanatory message"
git push
```
Note: the pipeline is triggered when commit/s is/are pushed to the repository.

## Thank you