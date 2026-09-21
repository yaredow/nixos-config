{ ... }: {
  flake.homeModules.zed = { pkgs, ... }: {
    programs.zed-editor = {
      enable = true;
      extraPackages = with pkgs; [
        nixd
        nixfmt
      ];
    };

    xdg.configFile."zed/settings.json".source = ./settings.json;
    xdg.configFile."zed/keymap.json".source = ./keymap.json;
  };
}
