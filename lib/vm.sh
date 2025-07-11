#!/bin/bash

create_vm() {
  STORAGE="local"
  # CLOUD_IMAGE wird jetzt in input.sh gesetzt

  echo "[+] Creating VM $VMID ($VMNAME)..."
  qm create $VMID \
    --name $VMNAME \
    --memory $MEMORY \
    --cores $CORES \
    --cpu host \
    --net0 virtio,bridge=$BRIDGE \
    --scsihw virtio-scsi-single
}

import_and_configure_disk() {
  echo "[+] Importing disk from QCOW2..."
  qm importdisk $VMID $CLOUD_IMAGE $STORAGE

  echo "[+] Searching for imported disk file..."
  DISK_NAME=$(ls /var/lib/vz/images/$VMID/ | grep -E '\.qcow2$|\.raw$' | head -n1)

  if [[ -z "$DISK_NAME" ]]; then
    echo "[!] No imported disk found – aborting."
    exit 1
  fi

  echo "[✓] Found disk: $DISK_NAME"

  echo "[+] Configuring boot disk..."
  qm set $VMID --scsi0 $STORAGE:$VMID/${DISK_NAME}
  qm set $VMID --boot c --bootdisk scsi0

  echo "[+] Setting disk size to ${DISK_SIZE}G..."
  qm resize $VMID scsi0 ${DISK_SIZE}G
}
