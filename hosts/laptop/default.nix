{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "laptop";

  # NEVER change this after initial install
  system.stateVersion = "26.05";
}
