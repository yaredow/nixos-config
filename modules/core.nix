{ pkgs, config, inputs, ... }:
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

  environment.systemPackages = with pkgs; [
  	antigravity-cli
  ];

  # Automatic Garbage Collection & Store Optimization
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;

  # Fish shell (system-level registration in /etc/shells)
  programs.fish.enable = true;

  # Run unpatched dynamic binaries on NixOS (for Mason, Treesitter, etc.)
  programs.nix-ld.enable = true;

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

  services.keyd = {
  	enable = true;
	keyboards.default = {
		ids = ["*"];
		settings = {
			main = {
				capslock = "overload(control, esc)";
			};
		};
	};
  };

  # Firmware and microcode
  hardware.enableAllFirmware = true;
}
