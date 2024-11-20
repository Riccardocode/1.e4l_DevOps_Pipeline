#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to check if a Vagrant VM is running
check_and_start_vm() {
  local vm_path="$1"
  local vm_name="$2"

  echo "Checking the status of the $vm_name environment..."
  cd "$vm_path"
  
  # Check VM status
  if vagrant status | grep -q "running"; then
    echo -e "${GREEN}[OK] $vm_name environment is already running.${NC}"
  else
    echo "Starting the $vm_name environment..."
    vagrant up
  fi
}

# Start the Integration VM
check_and_start_vm "../s2-automate-build/integration-server" "Integration"

# Start the Stage VM
check_and_start_vm "../../s3-automate-deploy/stage-vm" "Stage"

# Start the Production VM
check_and_start_vm "../../s3-automate-deploy/production-vm" "Production"
