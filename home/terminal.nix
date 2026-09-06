{ ... }:
{
  # Fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting  # Silence the default greeting
    '';
    shellAliases = {
      v = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
      gs = "git status";
      gc = "git commit";
      gp = "git push";
    };
  };

  # Eza (modern ls with git and icons)
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    git = true;
  };

  # Starship cross-shell prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    presets = [ "nerd-font-symbols" ];

    settings = {
      add_newline = false;
      palette = "tokyonight_night";

      palettes.tokyonight_night = {
        fg = "#c0caf5";
        bg = "#1a1b26";
        blue = "#7aa2f7";
        red = "#f7768e";
        green = "#9ece6a";
        yellow = "#e0af68";
        purple = "#bb9af7";
        teal = "#7dcfff";
      };

      directory = {
        home_symbol = "󰋞 ";
        read_only = " 󰌾";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        style = "bold yellow";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };

      os = {
        symbols = {
          NixOS = " ";
        };
      };
    };
  };

  # Kitty terminal
  programs.kitty = {
    enable = true;
    themeFile = "tokyo_night_night";

    settings = {
      font_family = "CaskaydiaCove Nerd Font";
      font_size = 10;
      disable_ligatures = "cursor";

      hide_window_decorations = "yes";
      window_padding_width = 8;
      remember_window_size = false;
      initial_window_width = 800;
      initial_window_height = 550;
      confirm_os_window_close = 0;

      # Transparency & dimming
      background_opacity = "0.98";
      inactive_text_alpha = "0.8";

      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # Layouts
      enabled_layouts = "Tall, Fat, Grid, *";

      # Scrollback & rendering performance
      scrollback_lines = 10000;
      sync_to_monitor = true;

      allow_remote_control = true;
      mouse_hide_wait = "-3.0";
      strip_trailing_spaces = "smart";
      enable_audio_bell = false;
    };

    keybindings = {
      "ctrl+alt+h" = "neighboring_window left";
      "ctrl+alt+j" = "neighboring_window down";
      "ctrl+alt+k" = "neighboring_window up";
      "ctrl+alt+l" = "neighboring_window right";

      "ctrl+shift+enter" = "launch --location=vsplit";

      "kitty_mod+plus" = "change_font_size all +2.0";
      "kitty_mod+minus" = "change_font_size all -2.0";
      "kitty_mod+0" = "change_font_size all 0";
    };
  };
}
