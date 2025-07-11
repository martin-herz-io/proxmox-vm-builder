#!/bin/bash

handle_template_and_start() {
  if [[ "$TEMPLATE" == "yes" ]]; then
    qm template $VMID
    echo "[✓] VM $VMID saved as template."
  else
    echo "[✓] VM $VMID created."
    if [[ "$AUTOSTART" == "yes" || "$AUTOSTART" =~ ^[Yy]$ ]]; then
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
