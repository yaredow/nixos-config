{ pkgs, ... }:
{
  imports = [
    ./terminal.nix
    ./hyprland.nix
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
    networkmanagerapplet
  ];

  fonts.fontconfig.enable = true;
}
