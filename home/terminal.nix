{ pkgs, theme, ... }:
{
  # Fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting  # Silence the default greeting
    '';
    shellAliases = {
      # Editors & system
      v = "nvim";
      c = "clear";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";

      # Git
      gs = "git status";
      gc = "git commit";
      gp = "git push";

      # Navigation & directories
      ccwd = "cd ~/Documents/code";

      # Development
      prd = "pnpm run dev";
      prb = "pnpm run build";
      nr = "npm run";
      nrd = "npm run dev";
      brd = "bun run dev";

      # Utilities
      oc = "opencode";
      ytt = "youtube-tui";
    };

    functions = {
      # Fuzzy find and edit files with nvim and bat preview
      fe = {
        description = "Fuzzy find and edit files with nvim and bat preview";
        body = ''
          set -l files (fd --type f --hidden --follow --exclude .git $argv | \
            fzf -m --preview 'bat --color=always --style=numbers {}' \
              --preview-window=right:60%)
          if test (count $files) -gt 0
            nvim $files
          end
        '';
      };

      # Fuzzy find in files using ripgrep and fzf
      fif = {
        description = "Find in files using ripgrep and fzf";
        body = ''
          if test (count $argv) -eq 0
            echo "Usage: fif <pattern>"
            return 1
          end
          set -l match (rg --line-number --no-heading $argv | \
            fzf --delimiter : --preview 'bat --color=always --line-range :500 {1}')
          if test -n "$match"
            set -l file (echo $match | awk -F: '{print $1}')
            set -l line (echo $match | awk -F: '{print $2}')
            nvim "+$line" "$file"
          end
        '';
      };

      # Fuzzy cd into directory
      fcd = {
        description = "Fuzzy cd into directory";
        body = ''
          set -l dir (fd --type d --hidden --follow --exclude .git $argv | fzf +m)
          if test -n "$dir"
            cd "$dir"
          end
        '';
      };

      # Fuzzy kill process
      fkill = {
        description = "Fuzzy kill process";
        body = ''
          set -l pid (ps -ef | sed 1d | fzf -m | awk '{print $2}')
          if test -n "$pid"
            echo $pid | xargs kill -9
          end
        '';
      };

      # Find video files and play with mpv (detached)
      fv = {
        description = "Find video files and play with mpv";
        body = ''
          set -l files (fd -e mp4 -e mkv -e avi -e webm -e mov -e flv --hidden --follow --exclude .git --exclude Android --exclude node_modules . ~ | \
            fzf -m --query="$argv" --delimiter=/ --with-nth='-1')
          if test (count $files) -gt 0
            nohup mpv --no-terminal $files >/dev/null 2>&1 &
          end
        '';
      };

      # Yazi wrapper to cd into directory on exit
      y = {
        description = "Yazi wrapper that changes directory on exit";
        body = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
            builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    historyWidget.fish.command = "";
  };

  # Eza (modern ls with git and icons)
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
  };

  # Zoxide (smarter cd command with z and zi)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
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
        fg = theme.colors.text;
        bg = theme.colors.base;
        blue = theme.colors.accent;
        red = theme.colors.red;
        green = theme.colors.green;
        yellow = theme.colors.yellow;
        purple = theme.colors.purple;
        teal = theme.colors.cyan;
      };

      directory = {
        style = "bold ${theme.colors.accent}";
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

      git_branch = {
        symbol = " ";
        style = "bold ${theme.colors.purple}";
        truncation_length = 15;
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      git_status = {
        style = "${theme.colors.yellow}";
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

      character = {
        success_symbol = " [󰁔](bold ${theme.colors.accent}) ";
        error_symbol = " [  ](bold ${theme.colors.red}) ";
      };

      cmd_duration = {
        min_time = 2000;
        style = "italic ${theme.colors.yellow}";
        format = "took [$duration]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "dimmed ${theme.colors.overlay}";
        format = "[$time]($style)";
      };

      nodejs = {
        symbol = "• 󰎙 ";
        format = "[$symbol]($style)";
        style = "bold ${theme.colors.accent}";
      };

      golang = {
        symbol = "•  ";
        format = "[$symbol]($style)";
        style = "bold ${theme.colors.cyan}";
      };

      rust = {
        symbol = "• 󱘗 ";
        format = "[$symbol]($style)";
        style = "bold ${theme.colors.orange}";
      };

      python = {
        symbol = "• 󱔎 ";
        format = "[$symbol]($style)";
        style = "bold ${theme.colors.yellow}";
      };

      lua = {
        symbol = "•  ";
        format = "[$symbol]($style)";
        style = "bold ${theme.colors.accent}";
      };

      docker_context = {
        symbol = "•  ";
        format = "[$symbol]($style)";
        only_with_files = true;
        style = "bold ${theme.colors.cyan}";
      };

      nix_shell = {
        symbol = "•  ";
        format = "[$symbol$state]($style) ";
        style = "bold ${theme.colors.accent}";
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
      font_family = theme.fonts.mono;
      font_size = 10;
      disable_ligatures = "cursor";

      hide_window_decorations = "yes";
      window_padding_width = 8;
      remember_window_size = false;
      initial_window_width = 800;
      initial_window_height = 550;
      confirm_os_window_close = 0;

      background_opacity = "0.98";
      inactive_text_alpha = "0.8";

      active_border_color = theme.colors.accent;
      inactive_border_color = theme.colors.surface2;

      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      enabled_layouts = "Tall, Fat, Grid, *";

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

  # Atuin shell history
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      enter_accept = true;
      theme.name = "tokyo-night";
      show_numeric_shortcuts = false;
      keymap_mode = "vim-insert";
    };
    themes."tokyo-night" = {
      theme = {
        name = "tokyo-night";
        parent = "default";
      };
      colors = {
        AlertInfo = theme.colors.cyan;
        AlertWarn = theme.colors.yellow;
        AlertError = theme.colors.red;
        Annotation = theme.colors.surface2;
        Base = theme.colors.subtext;
        Guidance = theme.colors.orange;
        Important = theme.colors.accent;
        Title = theme.colors.purple;
      };
    };
  };
}
