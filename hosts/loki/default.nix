{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/hardware.nix
  ];

  networking.hostName = "loki";

  system.stateVersion = "26.05";
}
