cd ~/
git clone https://github.com/Riccardocode/1.e4l_DevOps_Pipeline

cd ~/1.e4l_DevOps_Pipeline/s2-automate-build/integration-server

Start integration environment
vagrant up


set up the repository for backend:
~/1.e4l_DevOps_Pipeline/s2-automate-build/integration-server/playbook/provision_scripts/setup-repository-backend.sh

set up the repository for frontend:
~/1.e4l_DevOps_Pipeline/s2-automate-build/integration-server/playbook/provision_scripts/setup-repository-frontend.sh

Setup the runner inside the CI virtual machine
Open a new terminal
cd ~/1.e4l_DevOps_Pipeline/s2-automate-build/integration-server
vagrant ssh
~/provision_scripts/setup-gitlab-runner.sh

Create directory inside the integration VM
mkdir /home/vagrant/artefact-repository

Change rights to the directory
cd /home/vagrant
chmod 777 artefact-repository/


Start The Stage Virtual machine
cd ~/s3-automate-deploy/stage-vm
vagrant up