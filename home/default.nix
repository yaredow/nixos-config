{ pkgs, ... }:
{
  imports = [
    ./terminal.nix
    ./hyprland.nix
    ./neovim.nix
    ./fuzzel.nix
    ./gtk.nix
    ./waybar.nix
    ./osd.nix
    ./notifications.nix
  ];

  home.username = "yada";
  home.homeDirectory = "/home/yada";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    git
    fastfetch
    bat
    ripgrep
    fd
    wget
    unzip
    qbittorrent

    grim
    slurp
    wl-clipboard
    bluetui
    impala
    yazi
    mpv
    yt-dlp
    nautilus
    file-roller
  ];

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      theme_background = false;
    };
  };

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
