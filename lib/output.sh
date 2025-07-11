#!/bin/bash

handle_template_and_start() {
  read -p "Save as template? [y/N]: " TEMPLATE
  if [[ "$TEMPLATE" =~ ^[Yy]$ ]]; then
    qm template $VMID
    echo "[✓] VM $VMID saved as template."
  else
    echo "[✓] VM $VMID created."
    read -p "Start VM now? [Y/n]: " AUTOSTART
    AUTOSTART=${AUTOSTART:-Y}
    if [[ "$AUTOSTART" =~ ^[Yy]$ ]]; then
      qm start $VMID
      echo "[✓] VM $VMID started."
    else
      echo "[i] VM was not started."
    fi
  fi
}

display_credentials() {
  echo "====== Credentials ======"
  echo "Hostname: $VMNAME"
  echo "VM ID: $VMID"
  echo "Network: $VM_IP via $BRIDGE"
  echo "User: $CIUSER"
  echo "User password: $USERPASS"
  echo "Root password (console only!): $ROOTPASS"
  echo "SSH: ssh $CIUSER@$VM_IP"
  echo "========================="
}
