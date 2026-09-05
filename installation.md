# Bare Metal Installation Guide for NixOS

Follow this succinct step-by-step guide to install this configuration on your physical laptop.

---

## Step 1: Boot & Connect to Wi-Fi
Boot into the **NixOS Minimal Installer USB**.

```bash
# Start NetworkManager
systemctl start NetworkManager

# Connect to your Wi-Fi network (terminal GUI)
nmtui
# -> Select "Activate a connection" -> Choose your Wi-Fi -> Enter password

# Verify connection
ping -c 3 nixos.org
```

---

## Step 2: Disk Partitioning & Formatting
*(Using standard UEFI GPT layout on `/dev/nvme0n1`)*

> [!WARNING]
> This will wipe all data on the disk. Ensure you backed up any important files.

```bash
# 1. Create partition table and partitions
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1024MiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart root ext4 1024MiB 100%

# 2. Format partitions with labels (vital for seamless booting)
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -F -L nixos /dev/nvme0n1p2

# 3. Mount target partitions
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

---

## Step 3: Clone Configuration & Scan Hardware

```bash
# 1. Clone your repo directly into /mnt/etc/nixos
git clone https://github.com/yaredow/nixos-config.git /mnt/etc/nixos

# 2. Generate hardware scan directly into the laptop host folder
nixos-generate-config --root /mnt --dir /mnt/etc/nixos/hosts/laptop
```

---

## Step 4: Install System

```bash
cd /mnt/etc/nixos
git config --global --add safe.directory /mnt/etc/nixos
git add .

# Run installation with the #laptop flake target
nixos-install --flake .#laptop

# Set the root password when prompted
```

---

## Step 5: Reboot into NixOS

```bash
reboot
```
* Unplug the USB drive.
* You will be greeted by the minimal **tuigreet** login screen!
* **Username**: `yada`
* **Default Password**: `yada` (Change it with `passwd` after login)

---

## Quick Reference Keybindings
* **`SUPER + Q`** or **`SUPER + Return`**: Terminal (`kitty`)
* **`SUPER + Space`**: Application Launcher (`fuzzel`)
* **`SUPER + C`**: Close active window
* **`SUPER + E`**: Web Browser (`firefox`)
* **`SUPER + F`**: Toggle Fullscreen
* **`SUPER + V`**: Toggle Floating
* **`SUPER + 1-10`**: Switch Workspaces
* **`Fn Keys`**: Volume, Brightness, and Media controls

## Future Updates & Rebuilds
To apply configuration changes on your laptop:
```bash
sudo nixos-rebuild switch --flake ~/nixos-config#laptop
```
