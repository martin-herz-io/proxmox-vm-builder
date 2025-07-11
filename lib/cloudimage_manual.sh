#!/bin/bash

# Manual selection: ask for local or download, as before
select_cloud_image_manual() {
  echo "Do you have a local cloud image? (y/N): "
  read LOCAL_IMAGE
  LOCAL_IMAGE=${LOCAL_IMAGE:-N}

  if [[ "$LOCAL_IMAGE" =~ ^[Yy]$ ]]; then
    read -p "Enter local cloud image path (default: /var/lib/vz/template/qcow2/debian-12-genericcloud-amd64.qcow2): " CLOUD_IMAGE
    CLOUD_IMAGE=${CLOUD_IMAGE:-/var/lib/vz/template/qcow2/debian-12-genericcloud-amd64.qcow2}
    if [[ ! -f "$CLOUD_IMAGE" ]]; then
      echo "[!] File $CLOUD_IMAGE does not exist. Aborting."
      exit 1
    fi
  else
    read -p "Enter download URL for cloud image: " CLOUD_IMAGE_URL
    CLOUD_IMAGE="/var/lib/vz/template/qcow2/$(basename $CLOUD_IMAGE_URL)"
    if [[ ! -f "$CLOUD_IMAGE" ]]; then
      echo "[+] Downloading cloud image from $CLOUD_IMAGE_URL ..."
      mkdir -p /var/lib/vz/template/qcow2
      wget -O "$CLOUD_IMAGE" "$CLOUD_IMAGE_URL"
      if [[ $? -ne 0 ]]; then
        echo "[!] Download failed. Aborting."
        exit 1
      fi
    else
      echo "[✓] Cloud image already exists: $CLOUD_IMAGE"
    fi
  fi
}
