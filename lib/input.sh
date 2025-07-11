#!/bin/bash

source "$(dirname "$0")/lib/cloudimage_manual.sh"
source "$(dirname "$0")/lib/cloudimage_preset.sh"

collect_input() {
  # Helper for whiptail cancel
  abort_if_empty() {
    if [[ -z "$1" ]]; then
      echo "[!] Cancelled by user. Exiting."
      exit 1
    fi
  }

  if command -v whiptail >/dev/null 2>&1; then
    NODE=$(whiptail --inputbox "Node (default: pve)" 8 60 "pve" 3>&1 1>&2 2>&3)
    abort_if_empty "$NODE"
    NODE=${NODE:-pve}
    VMID=$(whiptail --inputbox "VM ID (e.g. 9000)" 8 60 "" 3>&1 1>&2 2>&3)
    abort_if_empty "$VMID"
    VMNAME=$(whiptail --inputbox "VM name" 8 60 "" 3>&1 1>&2 2>&3)
    abort_if_empty "$VMNAME"
    DISK_SIZE=$(whiptail --inputbox "Disk size (GiB)" 8 60 "" 3>&1 1>&2 2>&3)
    abort_if_empty "$DISK_SIZE"
    CORES=$(whiptail --inputbox "CPU cores" 8 60 "" 3>&1 1>&2 2>&3)
    abort_if_empty "$CORES"
    MEMORY_GIB=$(whiptail --inputbox "RAM (GiB)" 8 60 "" 3>&1 1>&2 2>&3)
    abort_if_empty "$MEMORY_GIB"
    MEMORY=$(( MEMORY_GIB * 1024 ))
    CIUSER=$(whiptail --inputbox "SSH username (e.g. admin)" 8 60 "" 3>&1 1>&2 2>&3)
    abort_if_empty "$CIUSER"
    IMAGE_MODE=$(whiptail --menu "How do you want to select the cloud image?" 15 60 2 \
      "1" "Manual (local path or custom URL)" \
      "2" "Preset (Debian/Ubuntu)" 3>&1 1>&2 2>&3)
    abort_if_empty "$IMAGE_MODE"
    IMAGE_MODE=${IMAGE_MODE:-2}
  else
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
  fi

  if [[ "$IMAGE_MODE" == "1" ]]; then
    select_cloud_image_manual
  else
    select_cloud_image_preset
  fi

  # Bridge Auswahl (nur whiptail)
  if command -v whiptail >/dev/null 2>&1; then
    # Netzwerkkarten abrufen (nur vmbrX, keine lo)
    BRIDGES=($(awk -F: '/^vmbr/ {print $1}' /proc/net/dev | tr -d ' '))
    if [[ ${#BRIDGES[@]} -eq 0 ]]; then
      BRIDGE="vmbr1"
    else
      BRIDGE_MENU=()
      for b in "${BRIDGES[@]}"; do
        BRIDGE_MENU+=("$b" "Proxmox Bridge $b")
      done
      BRIDGE=$(whiptail --menu "Select network bridge" 15 60 ${#BRIDGE_MENU[@]} "${BRIDGE_MENU[@]}" 3>&1 1>&2 2>&3)
      abort_if_empty "$BRIDGE"
    fi
  else
    read -p "Bridge (default: vmbr1): " BRIDGE
    BRIDGE=${BRIDGE:-vmbr1}
  fi

  SUBNET="192.168.100"
  if command -v whiptail >/dev/null 2>&1; then
    while true; do
      IP_LAST=$(whiptail --inputbox "Last octet for static IP (e.g. 10)" 8 60 "" 3>&1 1>&2 2>&3)
      abort_if_empty "$IP_LAST"
      VM_IP="$SUBNET.$IP_LAST"
      ping -c 1 -W 1 $VM_IP &>/dev/null
      if [[ $? -eq 0 ]]; then
        whiptail --msgbox "[!] IP $VM_IP is already in use – please choose another." 8 60
      else
        whiptail --msgbox "[✓] IP $VM_IP is available. Press OK to continue." 8 60
        break
      fi
    done
  else
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
  fi
  VM_GW="$SUBNET.1"

  if command -v whiptail >/dev/null 2>&1; then
    if whiptail --yesno "Save as template?" 8 60; then
      TEMPLATE="yes"
    else
      TEMPLATE="no"
    fi
    
    if [[ "$TEMPLATE" == "no" ]]; then
      if whiptail --yesno "Start VM now?" 8 60; then
        AUTOSTART="yes"
      else
        AUTOSTART="no"
      fi
    else
      AUTOSTART="no"
    fi
  else
    read -p "Save as template? [y/N]: " TEMPLATE
    if [[ "$TEMPLATE" =~ ^[Yy]$ ]]; then
      AUTOSTART="no"
    else
      read -p "Start VM now? [Y/n]: " AUTOSTART
      AUTOSTART=${AUTOSTART:-Y}
    fi
  fi
}
