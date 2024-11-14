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