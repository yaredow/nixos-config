{ self, inputs, ... }: {
  flake.nixosModules.antigravity = { pkgs, ... }: {
    environment.systemPackages = [
      inputs.antigravity-nix.packages.${pkgs.system}.default # Antigravity 2.0 Base App GUI (`antigravity`)
      inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-ide # Antigravity IDE GUI (`antigravity-ide`)
      inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli # Antigravity CLI (`agy`)
    ];
  };

  flake.homeModules.antigravity = { pkgs, ... }: {
    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.system}.default # Antigravity 2.0 Base App GUI (`antigravity`)
      inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-ide # Antigravity IDE GUI (`antigravity-ide`)
      inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli # Antigravity CLI (`agy`)
    ];
  };
}
