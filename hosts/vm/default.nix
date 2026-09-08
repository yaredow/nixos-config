{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/hardware.nix
  ];

  networking.hostName = "vm";

  # QEMU Guest Agent (host-guest clock sync, graceful shutdown from virt-manager UI)
  services.qemuGuest.enable = true;

  # SPICE Agent (clipboard sharing, dynamic display resolution resizing)
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;

  # Hyprland / Wayland VM optimizations
  environment.variables = {
    # Fix invisible cursor in virt-manager / SPICE viewers
    WLR_NO_HARDWARE_CURSORS = "1";
    # Allow software fallback if 3D acceleration is not toggled in virt-manager
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  # NEVER change this after initial install
  system.stateVersion = "26.05";
}
