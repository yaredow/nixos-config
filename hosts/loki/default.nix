{ ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/hardware.nix 
    ];

  networking.hostName = "loki";

  # NEVER change this after initial install
  system.stateVersion = "26.05";
}
