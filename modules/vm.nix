{ inputs, ... }:
{

  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.self.modules.nixos.hardware-vm

      # Base system configuration
      {
        networking.hostName = "vm";
        networking.networkmanager.enable = true;

        #Bootloader
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # User account
        users.users.yada = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };

        # SSH access
        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = true;
            PermitRootLogin = "no";
          };
        };

        # Nix settings
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
        nix.settings.trusted-users = ["root" "@wheel"];

        system.stateVersion = "25.05";
      }
    ];
  };
}
