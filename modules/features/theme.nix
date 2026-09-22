{ self, ... }: {
  # System level configuration for theming infrastructure
  flake.nixosModules.theme = { pkgs, ... }: {
    # Required for GTK/GNOME settings, dark mode preference, and dconf storage
    programs.dconf.enable = true;
    environment.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "adwaita";
      QT_STYLE_OVERRIDE = "adwaita-dark";
    };
  };

  # User level theme configuration
  flake.homeModules.theme = { pkgs, ... }: {
    # Pointer cursor
    home.pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    # GTK Theming (GTK 3, GTK 4 / Libadwaita)
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    # Qt Theming (bridges Qt apps like qBittorrent to dark theme)
    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };

    # System-wide dark mode preference for modern GTK4/libadwaita apps
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Papirus-Dark";
        cursor-theme = "Adwaita";
        cursor-size = 24;
        monospace-font-name = "JetBrainsMono Nerd Font 10";
      };
    };
  };
}
