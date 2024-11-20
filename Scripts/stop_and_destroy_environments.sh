#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to destroy a Vagrant VM
destroy_vm() {
  local vm_path="$1"
  local vm_name="$2"

  echo "Checking if the $vm_name environment exists..."
  cd "$vm_path"

  # Check if the VM exists
  if vagrant status | grep -q "not created"; then
    echo -e "${GREEN}[OK] $vm_name environment is already destroyed.${NC}"
  else
    echo -e "${YELLOW}[Info] $vm_name environment exists. Destroying it...${NC}"
    vagrant destroy -f
    echo -e "${GREEN}[OK] $vm_name environment destroyed.${NC}"
  fi
}

# Stop all VMs first
echo "Stopping all environments..."
./stop_all_vms.sh || {
  echo -e "${RED}[Error] Failed to stop environments. Aborting destroy operation.${NC}"
  exit 1
}

# Destroy the Integration VM
destroy_vm "../s2-automate-build/integration-server" "Integration"

# Destroy the Stage VM
destroy_vm "../../s3-automate-deploy/stage-vm" "Stage"

# Destroy the Production VM
destroy_vm "../../s3-automate-deploy/production-vm" "Production"
