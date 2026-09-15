# Loki Installation Guide (Fresh Wipe)

Since you are wiping your laptop SSD and installing from scratch, you cannot just run `nixos-rebuild`. You must boot from a Live USB, format the drive, and use `nixos-install`.

**CRITICAL WARNING:** When you wipe your SSD, your disk partitions get new, random UUIDs. The UUIDs currently hardcoded in `modules/hosts/loki/hardware.nix` will be wrong. If you don't update them, your new install will fail to boot because it won't be able to find the hard drive!

## Step 1: Boot and Partition
1. Boot into the NixOS Live USB.
2. Partition your disk (e.g., using `cfdisk /dev/nvme0n1`). You need at least:
   - A boot partition (e.g., 512MB, type EFI System)
   - A root partition (e.g., the rest of the disk, type Linux filesystem)
3. Format the partitions:
   ```bash
   mkfs.fat -F 32 -n boot /dev/nvme0n1p1
   mkfs.ext4 -L nixos /dev/nvme0n1p2
   ```
4. Mount them:
   ```bash
   mount /dev/disk/by-label/nixos /mnt
   mkdir -p /mnt/boot
   mount /dev/disk/by-label/boot /mnt/boot
   ```

## Step 2: Generate New Hardware Config
NixOS needs to know the new UUIDs of the partitions you just created.
```bash
nixos-generate-config --root /mnt
```
This generates `/mnt/etc/nixos/hardware-configuration.nix`.

## Step 3: Clone and Update Flake
1. Clone your configuration repo onto the mounted drive:
   ```bash
   nix-shell -p git
   git clone -b scratch-vm https://github.com/yaredow/nixos-config.git /mnt/etc/nixos-config
   cd /mnt/etc/nixos-config
   ```
2. Open `/mnt/etc/nixos/hardware-configuration.nix` (the newly generated one) and `/mnt/etc/nixos-config/modules/hosts/loki/hardware.nix` (the one in your repo) side-by-side.
3. **CRUCIAL STEP:** Copy the entire `fileSystems` block from the generated file into your repo's `hardware.nix`. This updates the UUIDs so your system knows where to boot from!

## Step 4: Install
Run the flake installer pointing to the `loki` configuration:
```bash
nixos-install --flake .#loki --root /mnt
```
It will build the system and ask you to set a root password.

## Step 5: Reboot
Once it finishes:
```bash
reboot
```
Remove your USB drive, and you will boot directly into the Noctalia Greeter!
