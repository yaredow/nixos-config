{ ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri.enable = true;
    services.greetd.enable = true;
    services.displayManager.noctalia-greeter.enable = true;
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  flake.homeModules.niri = { pkgs, ... }: {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    xdg.configFile."niri/config.kdl".source = ./config.kdl;
  };
}
