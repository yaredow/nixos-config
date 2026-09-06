{ ... }:
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

  # FZF (fuzzy finder with Fish shell integration: Ctrl+R history, Ctrl+T file, Alt+C cd)
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Eza (modern ls with git and icons)
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
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

      git_branch = {
        symbol = " ";
        style = "bold #bb9af7";
        truncation_length = 15;
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

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

      character = {
        success_symbol = " [󰁔](bold #7aa2f7) ";
        error_symbol = " [  ](bold #f7768e) ";
      };

      cmd_duration = {
        min_time = 2000;
        style = "italic #e0af68";
        format = "took [$duration]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "dimmed #565f89";
        format = "[$time]($style)";
      };

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
