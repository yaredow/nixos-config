{ self, ... }: {
  flake.nixosModules.vm-configuration = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    imports = [
      self.nixosModules.vm-hardware
      self.nixosModules.fish
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.keyd
      self.nixosModules.theme
      self.nixosModules.programs
    ];

    networking.hostName = "vm";
    networking.networkmanager.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.configurationLimit = 5;

    # System fonts
    fonts = {
      packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.caskaydia-cove
        nerd-fonts.jetbrains-mono
        inter
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
          monospace = [
            "JetBrainsMono Nerd Font"
            "DejaVu Sans Mono"
          ];
          sansSerif = [
            "Inter"
            "Noto Sans"
            "DejaVu Sans"
          ];
          serif = [
            "Noto Serif"
            "DejaVu Serif"
          ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };

    users.users.yada = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
      ];
    };

    virtualisation.docker.enable = true;

    programs.git.enable = true;

    environment.systemPackages = [
      pkgs.papirus-icon-theme
    ];

    services.spice-vdagentd.enable = true;

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
      substituters = [
        "https://nixos-cache-proxy.cofob.dev?priority=10"
        "https://cache.nixos.org"
      ];
      extra-substituters = [
        "https://noctalia.cachix.org"
      ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    # Timezone
    time.timeZone = "Africa/Addis_Ababa";

    # Fix dual/inverted cursor in VM by forcing software cursors
    environment.variables.WLR_NO_HARDWARE_CURSORS = "1";

    system.stateVersion = "26.05";

  };
}
