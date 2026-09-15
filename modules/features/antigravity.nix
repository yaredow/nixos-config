{ self, inputs, ... }: {
  flake.homeModules.antigravity = { pkgs, ... }: {

    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli
    ];
  };
}
