{ pkgs, theme, ... }:
{
  gtk = {
    enable = true;

    gtk4.extraCss = ''
      /* Tokyo Night Theme for Nautilus (GNOME Files) & Libadwaita */
      @define-color accent_color ${theme.colors.accent};
      @define-color accent_bg_color ${theme.colors.accent};
      @define-color accent_fg_color ${theme.colors.base};

      @define-color destructive_color ${theme.colors.red};
      @define-color destructive_bg_color ${theme.colors.red};
      @define-color destructive_fg_color ${theme.colors.base};

      @define-color success_color ${theme.colors.green};
      @define-color success_bg_color ${theme.colors.green};
      @define-color success_fg_color ${theme.colors.base};

      @define-color warning_color ${theme.colors.yellow};
      @define-color warning_bg_color ${theme.colors.yellow};
      @define-color warning_fg_color ${theme.colors.base};

      @define-color error_color ${theme.colors.red};
      @define-color error_bg_color ${theme.colors.red};
      @define-color error_fg_color ${theme.colors.base};

      /* Window & Surfaces */
      @define-color window_bg_color ${theme.colors.base};
      @define-color window_fg_color ${theme.colors.text};
      @define-color view_bg_color ${theme.colors.crust};
      @define-color view_fg_color ${theme.colors.text};

      /* Headerbar (Top Titlebar) */
      @define-color headerbar_bg_color ${theme.colors.crust};
      @define-color headerbar_fg_color ${theme.colors.text};
      @define-color headerbar_border_color rgba(122, 162, 247, 0.15);
      @define-color headerbar_backdrop_color ${theme.colors.crust};

      /* Nautilus Navigation Sidebar */
      @define-color sidebar_bg_color ${theme.colors.crust};
      @define-color sidebar_fg_color ${theme.colors.text};
      @define-color sidebar_backdrop_color ${theme.colors.crust};
      @define-color secondary_sidebar_bg_color ${theme.colors.crust};
      @define-color secondary_sidebar_fg_color ${theme.colors.text};

      /* Cards, Popovers & Dialogs */
      @define-color card_bg_color ${theme.colors.lighter};
      @define-color card_fg_color ${theme.colors.text};
      @define-color dialog_bg_color ${theme.colors.base};
      @define-color dialog_fg_color ${theme.colors.text};
      @define-color popover_bg_color ${theme.colors.lighter};
      @define-color popover_fg_color ${theme.colors.text};
    '';

    gtk3.extraCss = ''
      @define-color accent_color ${theme.colors.accent};
      @define-color accent_bg_color ${theme.colors.accent};
      @define-color window_bg_color ${theme.colors.base};
      @define-color window_fg_color ${theme.colors.text};
      @define-color view_bg_color ${theme.colors.crust};
      @define-color view_fg_color ${theme.colors.text};
      @define-color headerbar_bg_color ${theme.colors.crust};
      @define-color headerbar_fg_color ${theme.colors.text};
    '';
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };
}
