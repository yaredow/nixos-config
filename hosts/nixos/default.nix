{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "nixos";

  # VM-specific services
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  # NEVER change this after initial install
  system.stateVersion = "26.05";
}
