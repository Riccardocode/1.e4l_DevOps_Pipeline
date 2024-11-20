#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to check if a Vagrant VM is running and stop it
check_and_stop_vm() {
  local vm_path="$1"
  local vm_name="$2"

  echo "Checking the status of the $vm_name environment..."
  cd "$vm_path"
  
  # Check VM status
  if vagrant status | grep -q "running"; then
    echo -e "${YELLOW}[Info] $vm_name environment is running. Stopping it...${NC}"
    vagrant halt
    echo -e "${GREEN}[OK] $vm_name environment stopped.${NC}"
  else
    echo -e "${GREEN}[OK] $vm_name environment is already stopped.${NC}"
  fi
}

# Stop the Integration VM
check_and_stop_vm "../s2-automate-build/integration-server" "Integration"

# Stop the Stage VM
check_and_stop_vm "../../s3-automate-deploy/stage-vm" "Stage"

# Stop the Production VM
check_and_stop_vm "../../s3-automate-deploy/production-vm" "Production"
