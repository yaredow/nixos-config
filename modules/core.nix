{ pkgs, ... }:
{
  # Bootloader (systemd-boot with generation limit)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Locale & Timezone
  time.timeZone = "Africa/Addis_Ababa";
  i18n.defaultLocale = "en_US.UTF-8";

  # Networking
  networking.networkmanager.enable = true;

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Automatic Garbage Collection & Store Optimization
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;

  # Fish shell (system-level registration in /etc/shells)
  programs.fish.enable = true;

  # User account (initial password to prevent lockout on bare metal)
  users.users.yada = {
    isNormalUser = true;
    initialPassword = "yada";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
    shell = pkgs.fish;
  };

  # SSH (for remote access / maintenance)
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Firmware and microcode
  hardware.enableAllFirmware = true;
}
