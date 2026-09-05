# NixOS Configuration

Reproducible NixOS & Home Manager configuration for:
* **Host `nixos`**: Virtual Machine prototype
* **Host `laptop`**: Physical laptop workstation (Intel Alder Lake i5-12500H, Iris Xe, Realtek Wi-Fi)

## Stack
* **Compositor**: Hyprland (`hyprland.lua`)
* **Shell**: Fish (`programs.fish`)
* **Terminal**: Kitty (`programs.kitty`)
* **Audio**: Pipewire & Wireplumber
* **Network**: NetworkManager (`nmtui`)
* **Launcher**: Fuzzel

## Installation
For step-by-step bare-metal installation instructions, see [installation.md](installation.md).

## Rebuild
```bash
# On Laptop:
sudo nixos-rebuild switch --flake .#laptop

# On VM:
sudo nixos-rebuild switch --flake .#nixos
```
