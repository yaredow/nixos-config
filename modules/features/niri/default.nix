{ ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri.enable = true;
  };

  flake.homeModules.niri = { pkgs, ... }: {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    xdg.configFile."niri/config.kdl".source = ./config.kdl;
  };
}
