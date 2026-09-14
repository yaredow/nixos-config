{ self, ... }: {
  flake.nixosModules.vm-configuration = { pkgs, ... }: {
    imports = [
      self.nixosModules.vm-hardware
      self.nixosModules.fish
      self.nixosModules.niri
    ];

    networking.hostName = "vm";
    networking.networkmanager.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.configurationLimit = 5;

    # System fonts
    fonts = {
      packages = with pkgs; [
        nerd-fonts.caskaydia-cove
        nerd-fonts.fira-code
      ];
      fontconfig.defaultFonts.monospace = [ "FiraCode Nerd Font" ];
    };

    users.users.yada = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];

    };

    programs.git.enable = true;

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
    };

    system.stateVersion = "26.05";

  };
}
