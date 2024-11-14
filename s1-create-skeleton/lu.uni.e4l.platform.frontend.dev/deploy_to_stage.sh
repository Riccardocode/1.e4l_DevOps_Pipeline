#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Define paths
LOCAL_PATH="/home/vagrant/artefact-repository/*"
REMOTE_PATH="vagrant@192.168.56.7:/home/vagrant/stage"

# Run scp to copy files from integration VM to stage VM
scp -o StrictHostKeyChecking=no -i /home/vagrant/.ssh/id_rsa_stage -r $LOCAL_PATH $REMOTE_PATH

