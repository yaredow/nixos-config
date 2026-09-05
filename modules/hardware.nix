{ pkgs, ... }:
{
  # Audio — Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Brightness & audio control packages
  environment.systemPackages = with pkgs; [
    brightnessctl
    pamixer
    playerctl
    pavucontrol
  ];
}
