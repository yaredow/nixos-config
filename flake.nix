{
  description = "My Dendritic Nixos Configuration";

  inputs = {
    nixpkgs.url = "git+https://github.com/nixos/nixpkgs.git?ref=nixos-unstable&shallow=1";
    flake-parts.url = "git+https://github.com/hercules-ci/flake-parts.git";
    import-tree.url = "git+https://github.com/denful/import-tree.git";

    home-manager = {

      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
