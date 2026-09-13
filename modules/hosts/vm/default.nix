{ self, inputs, ... }: {
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.vm-configuration
      inputs.home-manager.nixosModules.home-manager

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.yada = {
            home.stateVersion = "26.05";
            imports = [ ];
          };

        };
      }
    ];
  };
}
