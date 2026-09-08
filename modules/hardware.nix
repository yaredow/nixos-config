{ pkgs, ... }:
{
  # Graphics & Hardware Acceleration (OpenGL / Mesa)
  hardware.graphics = {
    enable = true;
  };

  # Audio — Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Audio control packages
  environment.systemPackages = with pkgs; [
    pamixer
    playerctl
    pavucontrol
  ];
}
