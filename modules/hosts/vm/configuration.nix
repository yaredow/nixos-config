{ self, ... }: {
  flake.nixosModules.vm-configuration = { pkgs, ... }: {
    imports = [
      self.nixosModules.vm-hardware
    ];

    networking.hostName = "vm";
    networking.networkmanager.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

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
    };

    system.stateVersion = "26.05";

  };
}
