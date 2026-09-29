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
  flake.homeModules.theme = { pkgs, lib, ... }:
    let
      tokyoNightGtkCss = ''
        /* Tokyo Night theme for GTK 4 / Libadwaita and GTK 3 */
        @define-color window_bg_color #1a1b26;
        @define-color window_fg_color #a9b1d6;
        @define-color view_bg_color #1a1b26;
        @define-color view_fg_color #a9b1d6;
        @define-color headerbar_bg_color #1a1b26;
        @define-color headerbar_fg_color #a9b1d6;
        @define-color headerbar_backdrop_color #13141c;
        @define-color headerbar_shade_color rgba(65, 72, 104, 0.36);
        @define-color headerbar_darker_shade_color rgba(65, 72, 104, 0.6);
        @define-color sidebar_bg_color #13141c;
        @define-color sidebar_fg_color #a9b1d6;
        @define-color sidebar_backdrop_color #0e0e14;
        @define-color sidebar_shade_color rgba(65, 72, 104, 0.25);
        @define-color sidebar_border_color rgba(65, 72, 104, 0.36);
        @define-color secondary_sidebar_bg_color #0e0e14;
        @define-color secondary_sidebar_fg_color #a9b1d6;
        @define-color secondary_sidebar_backdrop_color #0e0e14;
        @define-color card_bg_color #24283b;
        @define-color card_fg_color #a9b1d6;
        @define-color card_shade_color rgba(65, 72, 104, 0.25);
        @define-color dialog_bg_color #24283b;
        @define-color dialog_fg_color #a9b1d6;
        @define-color popover_bg_color #24283b;
        @define-color popover_fg_color #a9b1d6;
        @define-color thumbnail_bg_color #24283b;
        @define-color thumbnail_fg_color #414868;
        @define-color accent_bg_color #7aa2f7;
        @define-color accent_fg_color #1a1b26;
        @define-color accent_color #7aa2f7;
        @define-color destructive_bg_color #f7768e;
        @define-color destructive_fg_color #ffffff;
        @define-color destructive_color #f7768e;
        @define-color success_bg_color #9ece6a;
        @define-color success_fg_color #ffffff;
        @define-color success_color #9ece6a;
        @define-color warning_bg_color #e0af68;
        @define-color warning_fg_color #1a1b26;
        @define-color warning_color #e0af68;
        @define-color error_bg_color #f7768e;
        @define-color error_fg_color #ffffff;
        @define-color error_color #f7768e;
        @define-color shade_color rgba(0, 0, 0, 0.36);
        @define-color scrollbar_outline_color rgba(255, 255, 255, 0.12);
      '';
    in
    {
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
      # Adopts Omarchy's icon configuration (Yaru-magenta matching Tokyo Night) and Tokyo Night palette
      gtk = {
        enable = true;
        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };
        iconTheme = {
          name = "Yaru-magenta";
          package = pkgs.yaru-theme;
        };
        gtk3.extraCss = tokyoNightGtkCss;
        gtk4.extraCss = tokyoNightGtkCss;
      };

      # Qt Theming (bridges Qt apps like qBittorrent to dark theme)
      qt = {
        enable = true;
        platformTheme.name = "adwaita";
        style.name = "adwaita-dark";
      };

      # Tokyo Night theme for qBittorrent
      xdg.configFile."qBittorrent/themes/tokyo-night.qbtheme".source =
        ../../assets/themes/tokyo-night.qbtheme;

      home.activation.configureQbittorrentTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        CONF="$HOME/.config/qBittorrent/qBittorrent.conf"
        THEME_PATH="$HOME/.config/qBittorrent/themes/tokyo-night.qbtheme"
        if [ -f "$CONF" ]; then
          if grep -q "\[Preferences\]" "$CONF"; then
            sed -i '/^General\\UseCustomUITheme=/d' "$CONF"
            sed -i '/^General\\CustomUIThemePath=/d' "$CONF"
            sed -i '/^\[Preferences\]/a General\\CustomUIThemePath='"$THEME_PATH"'\nGeneral\\UseCustomUITheme=true' "$CONF"
          else
            printf '\n[Preferences]\nGeneral\\CustomUIThemePath=%s\nGeneral\\UseCustomUITheme=true\n' "$THEME_PATH" >> "$CONF"
          fi
        fi
      '';

      # System-wide dark mode preference for modern GTK4/libadwaita apps
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3-dark";
          icon-theme = "Yaru-magenta";
          accent-color = "blue";
          cursor-theme = "Adwaita";
          cursor-size = 24;
          monospace-font-name = "JetBrainsMono Nerd Font 10";
        };
      };
    };
}
