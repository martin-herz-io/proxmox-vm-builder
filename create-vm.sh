#!/bin/bash

echo "====== Proxmox Debian Cloud-VM Setup with SSH & User ======"

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
