{ self, ... }:
{
  # System level
  flake.nixosModules.fish = { pkgs, ... }: {
    programs.fish.enable = true;
    users.users.yada.shell = pkgs.fish;
  };

  # User level
  flake.homeModules.fish = { pkgs, ... }: {
    programs.fish = {
      enable = true;

      shellInit = ''
        set -g fish_greeting

        if test -d "$HOME/.local/bin"
          if not contains "$HOME/.local/bin" $PATH
            set -gx PATH "$HOME/.local/bin" $PATH
          end
        end

        if test -d "$HOME/go/bin"
          if not contains "$HOME/go/bin" $PATH
            set -gx PATH "$HOME/go/bin" $PATH
          end
        end

        if test -d "$HOME/.bun/bin"
          if not contains "$HOME/.bun/bin" $PATH
            set -gx PATH "$HOME/.bun/bin" $PATH
          end
        end
      '';

      shellAliases = {
        ls = "eza --color=always";
        l = "eza";
        ll = "eza -lh --git";
        la = "eza -lha --git";
        tree = "eza --tree";

        gs = "git status";
        gc = "git commit";
        gp = "git push";

        c = "clear";
        ccwd = "cd ~/Documents/code";

        prd = "pnpm run dev";
        prb = "pnpm run build";
        nr = "npm run";
        nrd = "npm run dev";
        brd = "bun run dev";

        oc = "opencode";
        cy = "codex --approve-for-me";
        cx = "printf '\\033[2J\\033[3J\\033[H' && claude --permission-mode auto";
        ytt = "youtube-tui";
        dotfiles = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
        ase = "nohup emulator -avd Pixel_8 > /dev/null 2>&1 &!";
        rebuild = "sudo nixos-rebuild switch --flake .#loki --accept-flake-config";
        rebuild-vm = "sudo nixos-rebuild switch --flake .#vm --accept-flake-config";
      };

      functions = {
        fe = {
          description = "Open file with editor";
          body = ''
            set -l files (fd --type f --hidden --follow --exclude .git $argv | \
              fzf -m --preview 'bat --color=always --style=numbers {}' \
                --preview-window=right:60%)
            if test -n "$files"
              echo $files | xargs -d '\n' hx
            end
          '';
        };
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
        fcd = {
          description = "Fuzzy cd into directory";
          body = ''
            set -l dir (fd --type d --hidden --follow --exclude .git $argv | fzf +m)
            if test -n "$dir"
              cd "$dir"
            end
          '';
        };
        fkill = {
          description = "Fuzzy kill process";
          body = ''
            set -l pid (ps -ef | sed 1d | fzf -m | awk '{print $2}')
            if test -n "$pid"
              echo $pid | xargs kill -9
            end
          '';
        };
        fif = {
          description = "Find in files using ripgrep + fzf";
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
              hx "+$line" "$file"
            end
          '';
        };
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
  };
}
