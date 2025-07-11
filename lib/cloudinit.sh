#!/bin/bash

setup_cloudinit() {
  echo "[+] Enabling Cloud-Init..."
  qm set $VMID \
    --ide2 $STORAGE:cloudinit \
    --serial0 socket \
    --vga serial0

  echo "[+] Setting SSH user, password and network..."
  qm set $VMID \
    --ciuser $CIUSER \
    --cipassword "$USERPASS" \
    --ipconfig0 ip=$VM_IP/24,gw=$VM_GW \
    --searchdomain lan \
    --nameserver 8.8.8.8

  USERDATA="#cloud-config\nchpasswd:\n  list: |\n    root:$ROOTPASS\n    $CIUSER:$USERPASS\n  expire: false\nssh_pwauth: true\nusers:\n  - name: $CIUSER\n    sudo: ALL=(ALL) NOPASSWD:ALL\n    shell: /bin/bash\n"

  echo "$USERDATA" > /tmp/userdata-$VMID.yaml
  cp /tmp/userdata-$VMID.yaml /var/lib/vz/snippets/userdata-$VMID.yaml

  qm set $VMID --cicustom "user=local:snippets/userdata-$VMID.yaml"
  qm set $VMID --delete ciuser --delete cipassword
}
