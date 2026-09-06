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
      right_format = "$cmd_duration $time";

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

      # Smart directory styling with breadcrumbs & git repo truncation
      directory = {
        style = "bold #7aa2f7";
        truncation_length = 5;
        truncate_to_repo = true;
        substitutions = {
          "~" = "yada@loki";
          "/" = "  ";
          "Documents" = " 󰧮 ";
          "Downloads" = "  ";
          "Music" = "  ";
          "Pictures" = "  ";
          "Sources" = "  ";
        };
      };

      # Detailed Git branch
      git_branch = {
        symbol = " ";
        style = "bold #bb9af7";
        truncation_length = 15;
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      # Comprehensive Git status with badges & exact counts
      git_status = {
        style = "#e0af68";
        stashed = " \${count} ";
        ahead = "󰞙 \${count} ";
        behind = "󰞒 \${count} ";
        diverged = "󰵉 \${ahead_count} \${behind_count} ";
        conflicted = " \${count} ";
        deleted = " \${count} ";
        renamed = " \${count} ";
        modified = " \${count} ";
        staged = " \${count} ";
        untracked = "󱅘 \${count} ";
      };

      git_state = {
        rebase = "rebasing";
        merge = "merging";
        revert = "reverting";
        cherry_pick = " picking";
        bisect = "bisecting";
        am = "am'ing";
        am_or_rebase = "am/rebase";
      };

      # Sleek chevron on success, visual alert flags on error
      character = {
        success_symbol = " [󰁔](bold #7aa2f7) ";
        error_symbol = " [  ](bold #f7768e) ";
      };

      # Execution duration (only for commands taking > 2 seconds)
      cmd_duration = {
        min_time = 2000;
        style = "italic #e0af68";
        format = "took [$duration]($style)";
      };

      # Clean muted clock on the right
      time = {
        disabled = false;
        time_format = "%R";
        style = "dimmed #565f89";
        format = "[$time]($style)";
      };

      # Minimalist bullet-prefixed language indicators
      nodejs = {
        symbol = "• 󰎙 ";
        format = "[$symbol]($style)";
        style = "bold #7aa2f7";
      };

      golang = {
        symbol = "•  ";
        format = "[$symbol]($style)";
        style = "bold #7dcfff";
      };

      rust = {
        symbol = "• 󱘗 ";
        format = "[$symbol]($style)";
        style = "bold #ff9e64";
      };

      python = {
        symbol = "• 󱔎 ";
        format = "[$symbol]($style)";
        style = "bold #e0af68";
      };

      lua = {
        symbol = "•  ";
        format = "[$symbol]($style)";
        style = "bold #7aa2f7";
      };

      docker_context = {
        symbol = "•  ";
        format = "[$symbol]($style)";
        only_with_files = true;
        style = "bold #7dcfff";
      };

      nix_shell = {
        symbol = "•  ";
        format = "[$symbol$state]($style) ";
        style = "bold #7aa2f7";
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
