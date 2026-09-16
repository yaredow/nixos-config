{ lib, ... }:
{
  config = {
    systems = [
      "x86_64-linux"
    ];
  };

  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = { };
  };
}
