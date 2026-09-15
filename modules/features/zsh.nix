{ self, ... }:
{
  # System level
  flake.nixosModules.zsh = { pkgs, ... }: {
    programs.zsh.enable = true;
    users.users.yada.shell = pkgs.zsh;
  };

  # User level
  flake.homeModules.zsh = { pkgs, ... }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ls = "eza --color=always";
        l = "eza";
        ll = "eza -lh --git";
        la = "eza -lha --git";
        tree = "eza --tree";

        sp = "sudo pacman";
        sps = "sudo pacman -S --noconfirm";
        spu = "sudo pacman -Syu --noconfirm";

        gs = "git status";
        gc = "git commit";
        gp = "git push";

        v = "nvim";
        c = "clear";
        ccwd = "cd ~/Documents/code";

        prd = "pnpm run dev";
        prb = "pnpm run build";
        nr = "npm run";
        nrd = "npm run dev";
        brd = "bun run dev";

        oc = "opencode";
        ytt = "youtube-tui";
        dotfiles = "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
        ase = "nohup emulator -avd Pixel_8 > /dev/null 2>&1 &!";
        rebuild = "sudo nixos-rebuild switch --flake .#loki";
        rebuild-vm = "sudo nixos-rebuild switch --flake .#vm";
      };

      initExtra = ''
        # Environment variables and direnv
        export PNPM_HOME="$HOME/.local/share/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME/bin:"*) ;;
          *) export PATH="$PNPM_HOME/bin:$PATH" ;;
        esac
        export PATH="$PATH:$HOME/go/bin"
        [[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
        eval "$(direnv hook zsh)"
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="/home/yada/.local/share/mise/installs/node/26.5.0/bin:$PATH"\n\n        bindkey -v  # vi mode for command-line editing
        bindkey '^f' autosuggest-accept
        bindkey '^[[A' history-beginning-search-backward
        bindkey '^[[B' history-beginning-search-forward
        bindkey '^r' history-incremental-search-backward

        # fzf fe (open file with editor)
        fe() {
          local files
          files=$(fd --type f --hidden --follow --exclude .git "$@" | \
            fzf -m --preview 'bat --color=always --style=numbers {}' \
              --preview-window=right:60%)
          [[ -n "$files" ]] && echo "$files" | xargs -d '\n' ''${EDITOR:-nvim}
        }

        # fv (find video files and play with mpv)
        fv() {
          local files
          files=$(fd -e mp4 -e mkv -e avi -e webm -e mov -e flv --hidden --follow --exclude .git --exclude Android --exclude node_modules . ~ | \
            fzf -m --query="''${(j: :)@}" --delimiter=/ --with-nth='-1')
          if [[ -n "$files" ]]; then
            nohup mpv --no-terminal ''${(f)files} >/dev/null 2>&1 &
            exec true
          fi
        }

        # fcd (cd into selected directory)
        fcd() {
          local dir
          dir=$(fd --type d --hidden --follow --exclude .git "$@" | fzf +m)
          [[ -n "$dir" ]] && cd "$dir"
        }

        # fkill (kill process)
        fkill() {
          local pid
          pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
          [[ -n "$pid" ]] && echo "$pid" | xargs kill -9
        }

        # fif (find in files)
        fif() {
          if [[ ! "$#" -gt 0 ]]; then echo "Usage: fif <pattern>"; return 1; fi
          rg --line-number --no-heading "$@" | \
            fzf --delimiter : --preview 'bat --color=always --line-range :500 {1}' | \
            awk -F: '{print $1}' | xargs -r ''${EDITOR:-nvim}
        }

        # yazi wrapper
        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }
      '';
    };
  };
}
