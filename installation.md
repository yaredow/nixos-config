# NixOS Installation Guide

This repository contains two host configurations:
* **`vm`**: Virtual Machine optimized for **virt-manager / QEMU / KVM** (VirtIO drivers, SPICE clipboard & dynamic resize, QEMU guest agent, Wayland VM cursor fixes).
* **`loki`**: Bare-metal physical laptop workstation (Intel Alder Lake i5-12500H, Iris Xe graphics acceleration, Bluetooth, power profiles).

---

## Part A: Virt-Manager (QEMU/KVM) Installation

### Step 1: Create the Virtual Machine in virt-manager

1. Open **Virtual Machine Manager** (`virt-manager`).
2. Click **New Virtual Machine** (top left).
3. Select **Local install media (ISO image)** and choose your downloaded NixOS ISO (e.g. `nixos-minimal-...-x86_64-linux.iso` or graphical ISO).
4. **RAM & CPU**:
   * Memory: At least **4096 MB** (4 GB) or **8192 MB** (recommended).
   * CPUs: At least **2 vCPUs** (4 vCPUs recommended).
5. **Storage**:
   * Create a virtual disk of at least **30 GB** or larger.
6. **Customize Configuration**:
   * Check **"Customize configuration before install"** and click **Finish**.

### Step 2: Configure VM Hardware Settings

Before starting the installation, configure the following hardware details in the VM settings window:

| Device | Setting | Note |
| :--- | :--- | :--- |
| **Overview -> Firmware** | **`UEFI (OVMF)`** / `x86_64: ...OVMF_CODE...` | **Mandatory**: `systemd-boot` requires UEFI. Do NOT use BIOS/SeaBIOS. |
| **Overview -> Chipset** | **`Q35`** | Modern PC architecture with native PCIe support. |
| **Disk 1** | Disk bus: **`VirtIO`** | Provides high-performance virtual block storage (`/dev/vda`). |
| **NIC (Network)** | Device model: **`virtio`** | VirtIO paravirtualized network adapter. |
| **Display Spice** | Listen type: `None` or `Address` | Standard SPICE display server. |
| **Video** | Model: **`Virtio`** (check **3D acceleration** if host supports it) | Accelerates Wayland/Hyprland. Software fallback is also supported. |
| **Channel (Spice)** | Channel name: **`com.redhat.spice.0`** | Enables guest agent for clipboard sharing and dynamic screen resizing. |
| **Channel (QEMU Agent)** | Add Hardware -> Channel -> **`org.qemu.guest_agent.0`** | Enables clean host-initiated shutdown/reboot and guest telemetry. |

Click **Begin Installation** (top left) to boot the NixOS live environment.

---

### Step 3: Disk Partitioning & Formatting (Inside VM)

Once booted into the NixOS installer shell:

```bash
# 1. Create GPT partition table and EFI + Root partitions on /dev/vda
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart ESP fat32 1MiB 1024MiB
parted /dev/vda -- set 1 esp on
parted /dev/vda -- mkpart root ext4 1024MiB 100%

# 2. Format partitions with persistent labels
mkfs.fat -F 32 -n boot /dev/vda1
mkfs.ext4 -F -L nixos /dev/vda2

# 3. Mount target partitions
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

> [!NOTE]
> We use filesystem labels (`nixos` and `boot`). This guarantees reliable boot without relying on fragile UUIDs, even if the virtual drive bus changes. Compressed RAM swap (`zramSwap`) is enabled by default, so no disk swap partition is required.

---

### Step 4: Clone Configuration & Install

```bash
# 1. Clone this repository into /mnt/etc/nixos
git clone https://github.com/yaredow/nixos-config.git /mnt/etc/nixos

# 2. Enter configuration directory
cd /mnt/etc/nixos
git config --global --add safe.directory /mnt/etc/nixos
git add .

# 3. Install the VM configuration
nixos-install --flake .#vm
```

When prompted, set the root password (or press Enter if prompted).

---

### Step 5: Reboot into the VM

```bash
reboot
```

1. In `virt-manager`, detach or unmount the installer ISO from the virtual CD-ROM.
2. The VM will boot cleanly through `systemd-boot` into the minimal **tuigreet** login console.
3. **Username**: `yada`
4. **Default Password**: `yada` (Change it with `passwd` after login).
5. Upon logging in, Hyprland will start with full Tokyo Night theming, Kitty, Waybar, and Fuzzel.
6. **SPICE Integration**: Resizing the virt-manager viewer window will automatically adjust the guest resolution, and clipboard sharing is enabled out of the box.

---

## Part B: Bare-Metal Laptop Installation (`loki`)

### Step 1: Boot & Connect to Wi-Fi
Boot into the **NixOS Minimal Installer USB**.

```bash
# Start NetworkManager and connect to Wi-Fi
systemctl start NetworkManager
nmtui
# -> Select "Activate a connection" -> Choose Wi-Fi -> Enter password

# Verify connection
ping -c 3 nixos.org
```

### Step 2: Disk Partitioning & Formatting (`/dev/nvme0n1`)

> [!WARNING]
> This will wipe all data on the target drive. Ensure you have backed up any important files.

```bash
# 1. Create partition table and partitions
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1024MiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart root ext4 1024MiB 100%

# 2. Format partitions with labels
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -F -L nixos /dev/nvme0n1p2

# 3. Mount target partitions
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

### Step 3: Clone Configuration & Scan Hardware

```bash
# 1. Clone repository directly into /mnt/etc/nixos
git clone https://github.com/yaredow/nixos-config.git /mnt/etc/nixos

# 2. (Optional) Re-scan laptop hardware configuration if needed:
# nixos-generate-config --root /mnt --dir /mnt/etc/nixos/hosts/loki
```

### Step 4: Install System

```bash
cd /mnt/etc/nixos
git config --global --add safe.directory /mnt/etc/nixos
git add .

# Run installation for the laptop target
nixos-install --flake .#loki

# Set root password when prompted
```

### Step 5: Reboot into NixOS

```bash
reboot
```
* Unplug the installer USB drive.
* Login via **tuigreet** with username `yada` and password `yada`.

---

## Post-Install & Future Updates

To apply configuration changes on either system, navigate to your repo and run:

* On the **Virtual Machine**:
  ```bash
  sudo nixos-rebuild switch --flake ~/nixos-config#vm
  ```

* On the **Physical Laptop**:
  ```bash
  sudo nixos-rebuild switch --flake ~/nixos-config#loki
  ```

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
