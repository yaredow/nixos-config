{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/hardware.nix
  ];

  networking.hostName = "loki";

  # Laptop-specific graphics acceleration (Intel Iris Xe)
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt
  ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Power management & display brightness
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  system.stateVersion = "26.05";
}

