#!/bin/bash

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

  read -p "Bridge (default: vmbr1): " BRIDGE
  BRIDGE=${BRIDGE:-vmbr1}

  if [[ "$BRIDGE" == "vmbr1" ]]; then
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
  else
    read -p "Static public IP (e.g. 162.55.X.Y): " VM_IP
    read -p "Gateway (e.g. 162.55.X.1): " VM_GW
  fi
}
