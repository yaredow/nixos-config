{ pkgs, ... }:
{
  imports = [
    ./terminal.nix
    ./hyprland.nix
    ./neovim.nix
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
    wget
    unzip

    fuzzel
    grim
    slurp
    wl-clipboard
    bluetui
    impala
    yazi
    mpv
  ];

  fonts.fontconfig.enable = true;
}
