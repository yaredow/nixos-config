# NixOS Configuration

Reproducible NixOS & Home Manager configuration for **Host `loki`**: Physical laptop workstation (Intel Alder Lake i5-12500H, Iris Xe, Realtek Wi-Fi).

## Stack
* **Compositor**: Hyprland (Home Manager `wayland.windowManager.hyprland`)
* **Shell**: Fish (`programs.fish`)
* **Terminal**: Kitty (`programs.kitty`)
* **Audio**: Pipewire & Wireplumber
* **Network**: NetworkManager (`nmtui`)
* **Launcher**: Fuzzel

## Installation
For step-by-step bare-metal installation instructions, see [installation.md](installation.md).

## Rebuild
```bash
sudo nixos-rebuild switch --flake .#loki
```
