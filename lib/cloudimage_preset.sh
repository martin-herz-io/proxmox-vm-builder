#!/bin/bash

select_cloud_image_preset() {
  if command -v whiptail >/dev/null 2>&1; then
    PRESET=$(whiptail --title "Cloud Image Preset" --menu "Choose a cloud image preset:" 15 60 4 \
      "1" "Debian 12 (default)" \
      "2" "Debian 11" \
      "3" "Ubuntu 22.04 LTS" \
      "4" "Ubuntu 20.04 LTS" 3>&1 1>&2 2>&3)
    PRESET=${PRESET:-1}
  else
    echo "Choose a cloud image preset:"
    echo "1) Debian 12 (default)"
    echo "2) Debian 11"
    echo "3) Ubuntu 22.04 LTS"
    echo "4) Ubuntu 20.04 LTS"
    read -p "Selection [1-4]: " PRESET
    PRESET=${PRESET:-1}
  fi

  case $PRESET in
    1)
      CLOUD_IMAGE="/var/lib/vz/template/qcow2/debian-12-genericcloud-amd64.qcow2"
      CLOUD_IMAGE_URL="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
      ;;
    2)
      CLOUD_IMAGE="/var/lib/vz/template/qcow2/debian-11-genericcloud-amd64.qcow2"
      CLOUD_IMAGE_URL="https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
      ;;
    3)
      CLOUD_IMAGE="/var/lib/vz/template/qcow2/ubuntu-22.04-server-cloudimg-amd64.img"
      CLOUD_IMAGE_URL="https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
      ;;
    4)
      CLOUD_IMAGE="/var/lib/vz/template/qcow2/ubuntu-20.04-server-cloudimg-amd64.img"
      CLOUD_IMAGE_URL="https://cloud-images.ubuntu.com/releases/20.04/release/ubuntu-20.04-server-cloudimg-amd64.img"
      ;;
    *)
      echo "[!] Invalid selection. Aborting."
      exit 1
      ;;
  esac

  if [[ -f "$CLOUD_IMAGE" ]]; then
    echo "[✓] Cloud image already exists: $CLOUD_IMAGE"
  else
    echo "[+] Downloading cloud image from $CLOUD_IMAGE_URL ..."
    mkdir -p /var/lib/vz/template/qcow2
    wget -O "$CLOUD_IMAGE" "$CLOUD_IMAGE_URL"
    if [[ $? -ne 0 ]]; then
      echo "[!] Download failed. Aborting."
      exit 1
    fi
  fi
}