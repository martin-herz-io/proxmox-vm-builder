#!/bin/bash

source "$(dirname "$0")/lib/cloudimage_manual.sh"
source "$(dirname "$0")/lib/cloudimage_preset.sh"

collect_input() {
  read -p "Node (default: pve): " NODE
  NODE=${NODE:-pve}

  read -p "VM ID (e.g. 9000): " VMID
  read -p "VM name: " VMNAME
  read -p "Disk size (GiB): " DISK_SIZE
  read -p "CPU cores: " CORES
  read -p "RAM (GiB): " MEMORY_GIB
  MEMORY=$(( MEMORY_GIB * 1024 ))
  read -p "SSH username (e.g. admin): " CIUSER

  echo "How do you want to select the cloud image?"
  echo "1) Manual (local path or custom URL)"
  echo "2) Preset (Debian/Ubuntu)"
  read -p "Selection [1-2]: " IMAGE_MODE
  IMAGE_MODE=${IMAGE_MODE:-2}

  if [[ "$IMAGE_MODE" == "1" ]]; then
    select_cloud_image_manual
  else
    select_cloud_image_preset
  fi

  read -p "Bridge (default: vmbr1): " BRIDGE
  BRIDGE=${BRIDGE:-vmbr1}

  SUBNET="192.168.100"
    while true; do
      read -p "Last octet for static IP (e.g. 10): " IP_LAST
      VM_IP="$SUBNET.$IP_LAST"
      ping -c 1 -W 1 $VM_IP &>/dev/null
      if [[ $? -eq 0 ]]; then
        echo "[!] IP $VM_IP is already in use – please choose another."
      else
        echo "[✓] IP $VM_IP is available."
        break
      fi
    done
    
  VM_GW="$SUBNET.1"
}
