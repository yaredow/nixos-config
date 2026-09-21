# Installation Guide (Loki)

Assuming your target partitions are already formatted and mounted at `/mnt` and `/mnt/boot`:

## 1. Generate Hardware Config
Generate hardware config to get your new partition UUIDs:
```bash
nixos-generate-config --root /mnt
```

## 2. Clone Config & Update UUIDs
1. Enter a Nix shell with Git and clone the configuration:
   ```bash
   nix-shell -p git
   git clone https://github.com/yaredow/nixos-config.git /mnt/etc/nixos-config
   cd /mnt/etc/nixos-config
   ```

2. Open `/mnt/etc/nixos/hardware-configuration.nix` and copy the `fileSystems` blocks (root and boot UUIDs) into:
   ```text
   modules/hosts/loki/hardware.nix
   ```

## 3. Install System
Install the `loki` flake configuration:
```bash
nixos-install --flake .#loki --accept-flake-config
```
Set your user password when prompted.

## 4. Reboot
```bash
reboot
```
Remove the installation USB.
