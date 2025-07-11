# Proxmox VM Builder

A modular Bash script to automate the creation of cloud-ready virtual machines (VMs) on Proxmox VE, supporting both manual and preset-based cloud image selection (Debian, Ubuntu, etc.).

## Features
- Interactive setup for all essential VM parameters
- Automatic or manual selection of cloud images (Debian/Ubuntu presets or custom images/URLs)
- Automatic download of missing cloud images
- Cloud-Init configuration for SSH user, passwords, and network
- Option to create a VM template or start the VM immediately
- Modular code structure for easy maintenance and extension

## Usage

1. **Clone this repository and enter the directory:**
   ```bash
   git clone https://github.com/martin-herz-io/proxmox-vm-builder.git
   cd proxmox-vm-builder
   ```

2. **Make the main script executable:**
   ```bash
   chmod +x create-vm.sh
   ```

3. **Run the script as root (or with sufficient Proxmox privileges):**
   ```bash
   sudo ./create-vm.sh
   ```

4. **Follow the interactive prompts:**
   - Enter VM details (name, ID, resources, etc.)
   - Choose between manual or preset-based cloud image selection
   - If preset: select from Debian/Ubuntu images (automatic download if missing)
   - If manual: specify a local image or provide a download URL
   - Configure network and user settings
   - Decide whether to save as template or start the VM

## Directory Structure

- `create-vm.sh` — Main entry script
- `lib/` — Modular Bash scripts for input, VM creation, cloud image handling, etc.
  - `input.sh` — Collects user input
  - `cloudimage_manual.sh` — Manual image selection/download
  - `cloudimage_preset.sh` — Preset image selection/download
  - `vm.sh`, `cloudinit.sh`, `output.sh`, `passwords.sh` — Further modular logic

## Requirements
- Proxmox VE (tested on 8.x)
- Bash
- `wget` (for image download)
- `whiptail` (optional, for nicer menus)
- Sufficient permissions to create VMs and write to `/var/lib/vz/template/qcow2`

## Disclaimer
This script is provided "as is" without any warranty. Use at your own risk. Always review and test scripts in a safe environment before using them in production. The author is not responsible for any damage or data loss resulting from the use of this script.

## Background & Motivation
Proxmox VE is a powerful virtualization platform, but creating cloud-ready VMs (with Cloud-Init, SSH, etc.) can be repetitive and error-prone. This script streamlines the process, making it easy to deploy new VMs or templates with best practices and minimal manual effort. The modular structure allows for easy customization and future extension (e.g., more OS presets, advanced networking, etc.).
