{ pkgs, ... }:
{
  imports = [
    ./terminal.nix
    ./hyprland.nix
    ./neovim.nix
    ./fuzzel.nix
    ./gtk.nix
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
    qbittorrent

    zoxide
    grim
    slurp
    wl-clipboard
    bluetui
    impala
    yazi
    mpv
    nautilus
    file-roller
  ];

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
