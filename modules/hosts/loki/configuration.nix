{ self, ... }: {
  flake.nixosModules.loki-configuration = { pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
    imports = [
      self.nixosModules.loki-hardware
      self.nixosModules.fish
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.keyd
    ];

    networking.hostName = "loki";
    networking.networkmanager.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;

    # Laptop-specific graphics acceleration (Intel Iris Xe)
    hardware.graphics.extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];

    # Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    # Power management & display brightness
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    environment.systemPackages = with pkgs; [
      brightnessctl
      papirus-icon-theme
    ];

    # System fonts
    fonts = {
      packages = with pkgs; [
        inter
        nerd-fonts.caskaydia-cove
        nerd-fonts.fira-code
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        dejavu_fonts
      ];
      fontconfig = {
        enable = true;
        antialias = true;
        hinting = {
          enable = true;
          style = "slight";
        };
        subpixel = {
          rgba = "rgb";
          lcdfilter = "default";
        };
        defaultFonts = {
          monospace = [ "FiraCode Nerd Font" "DejaVu Sans Mono" ];
          sansSerif = [ "Inter" "Noto Sans" "DejaVu Sans" ];
          serif = [ "Noto Serif" "DejaVu Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };

    users.users.yada = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };

    programs.git.enable = true;

    # SSH access
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };

    # Nix settings
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      extra-substituters = [
        "https://noctalia.cachix.org"
      ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    system.stateVersion = "26.05";
  };
}
