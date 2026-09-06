{
  description = "Yada's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, antigravity-nix, ... }: {
    nixosConfigurations = {

      loki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
	  {
          nixpkgs.overlays = [
            antigravity-nix.overlays.default
          ];
          }

          ./hosts/loki
          ./modules/core.nix
          ./modules/hardware.nix
          ./modules/desktop.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.yada = import ./home;
          }
        ];
      };

    };
  };
}
