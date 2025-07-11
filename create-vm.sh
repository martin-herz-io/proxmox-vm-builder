#!/bin/bash

echo "==============================================="
echo " Proxmox Debian Cloud-VM Setup with SSH & User "
echo "-----------------------------------------------"
echo " Author : Martin-Andree Herz"
echo " Version: 1.0.0"
echo " GitHub : https://github.com/martin-herz-io/proxmox-vm-builder"
echo " Website : https://martin-herz.io"
echo "==============================================="

# Module einbinden
source "$(dirname "$0")/lib/input.sh"
source "$(dirname "$0")/lib/passwords.sh"
source "$(dirname "$0")/lib/vm.sh"
source "$(dirname "$0")/lib/cloudinit.sh"
source "$(dirname "$0")/lib/output.sh"

# Eingaben sammeln
collect_input

generate_passwords

create_vm
import_and_configure_disk
setup_cloudinit
handle_template_and_start
display_credentials
