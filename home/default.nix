{ pkgs, ... }:
{
  imports = [
    ./terminal.nix
  ];

  home.username = "yada";
  home.homeDirectory = "/home/yada";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    git
    fastfetch
    btop
    bat
    ripgrep
    fd
    neovim
    wget
    unzip

    fuzzel
    grim
    slurp
    wl-clipboard
  ];

  xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

  fonts.fontconfig.enable = true;
}
