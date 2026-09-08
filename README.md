# NixOS Configuration

Reproducible NixOS & Home Manager configuration supporting two target hosts:
* **Host `loki`**: Physical laptop workstation (Intel Alder Lake i5-12500H, Iris Xe, Realtek Wi-Fi, Bluetooth, power management).
* **Host `vm`**: Virtual machine optimized for **virt-manager (QEMU/KVM)** (VirtIO drivers, SPICE clipboard & dynamic display resizing, QEMU guest agent, Wayland VM cursor fixes).

## Stack
* **Compositor**: Hyprland (Home Manager `wayland.windowManager.hyprland`)
* **Shell**: Fish (`programs.fish`)
* **Terminal**: Kitty (`programs.kitty`)
* **Audio**: Pipewire & Wireplumber
* **Network**: NetworkManager (`nmtui`)
* **Launcher**: Fuzzel
* **Theming**: Tokyo Night (Kitty, Waybar, Neovim, Fuzzel, SwayNC, SwayOSD)

## Installation
For step-by-step instructions for both virt-manager and bare-metal, see [installation.md](installation.md).

## Rebuild
```bash
# On the laptop
sudo nixos-rebuild switch --flake .#loki

# On the virtual machine
sudo nixos-rebuild switch --flake .#vm
```

