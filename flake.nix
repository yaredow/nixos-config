{
  description = "My Dendritic Nixos Configuration";

  nixConfig = {
    extra-substituters = [
      "https://nixos-cache-proxy.cofob.dev?priority=10"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "git+https://github.com/nixos/nixpkgs.git?ref=nixos-unstable&shallow=1";
    flake-parts.url = "git+https://github.com/hercules-ci/flake-parts.git";
    import-tree.url = "git+https://github.com/denful/import-tree.git";

    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    home-manager = {

      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
