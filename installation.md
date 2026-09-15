# Loki Installation Guide

Follow these steps to apply this flake configuration to your main laptop (`loki`).

## Prerequisites
- You must already be running NixOS on `loki`.
- (If this is a brand new, wiped disk install, the UUIDs in `modules/hosts/loki/hardware.nix` will be incorrect. You must generate a new hardware config via `nixos-generate-config --show-hardware-config` and update `hardware.nix` with the new UUIDs before proceeding).

## Step 1: Clone the Repository
Open a terminal on your laptop and clone your configuration repository if you haven't already:

```bash
git clone git@github.com:yaredow/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

## Step 2: Checkout the Working Branch
The new Dendritic configuration for `loki` is currently on the `scratch-vm` branch. Fetch and checkout this branch:

```bash
git fetch origin
git checkout scratch-vm
git pull origin scratch-vm
```

## Step 3: Build and Switch
Deploy the flake to the system. Since the flake defines `nixosConfigurations.loki`, it will automatically use the `loki` configuration because it matches your hostname (or you can specify it explicitly).

```bash
sudo nixos-rebuild switch --flake .#loki
```

## Step 4: Finalize
1. The build will download and compile the necessary packages (Noctalia, Niri, etc.).
2. Once completed, the system display manager will likely restart, throwing you into the `noctalia-greeter` login screen.
3. Log in with your password. You should now be in your new Niri Wayland session.

## Troubleshooting
- **No Route to Host / Network Issues**: Make sure you are connected to the internet before running `nixos-rebuild`.
- **Disk UUID Errors**: If you wiped your drive and reinstalled from a USB, your partition UUIDs have changed. Run `sudo nixos-generate-config` and copy the new UUIDs into `modules/hosts/loki/hardware.nix`, then rebuild.
