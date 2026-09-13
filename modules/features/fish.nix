{ self, ... }:
{
  # System level
  flake.nixosModules.fish = { pkgs, ... }: {
    programs.fish.enable = true;
    users.users.yada.shell = pkgs.fish;
  };

  # User level
  flake.homeModules.fish = { ... }: {
    programs.fish = {
      enable = true;

      shellInit = "
          set -g fish_greeting
        ";

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake .#vm";
      };
    };
  };
}
