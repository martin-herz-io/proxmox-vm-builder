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

  USERDATA="#cloud-config
chpasswd:
  list: |
    root:$ROOTPASS
    $CIUSER:$USERPASS
  expire: false
ssh_pwauth: true
runcmd:
  - echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
  - echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
  - sysctl -w net.ipv6.conf.all.disable_ipv6=1
  - sysctl -w net.ipv6.conf.default.disable_ipv6=1
users:
  - name: $CIUSER
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    passwd: $USERPASS
    lock_passwd: false
"

  echo "$USERDATA" > /tmp/userdata-$VMID.yaml
  cp /tmp/userdata-$VMID.yaml /var/lib/vz/snippets/userdata-$VMID.yaml

  qm set $VMID --cicustom "user=local:snippets/userdata-$VMID.yaml"
  qm set $VMID --delete ciuser --delete cipassword
}
