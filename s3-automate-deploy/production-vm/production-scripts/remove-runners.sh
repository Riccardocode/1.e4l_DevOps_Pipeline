#!/bin/bash 

sudo gitlab-runner unregister -name stage-backend-shell
sudo gitlab-runner unregister -name stage-frontend-shell

sudo gitlab-runner list