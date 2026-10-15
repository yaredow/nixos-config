{ self, inputs, ... }: {
  flake.nixosModules.programs = { pkgs, ... }: {
    services.gvfs.enable = true;
    services.tumbler.enable = true;
  };

  flake.homeModules.programs = { pkgs, ... }: {
    home.packages = with pkgs; [
      fastfetch
      ripgrep
      fd
      wget
      unzip
      qbittorrent
      yazi
      yt-dlp
      cliamp
      telegram-desktop
      nautilus
      loupe
      evince
      gnumake
      docker-compose
      spotify
      speedtest-cli
      cursor-cli
      lazygit
      fprintd
      slurp

      go
      gopls
      delve
      golangci-lint
      golangci-lint-langserver
      gofumpt

      bun
      typescript
      typescript-language-server
    ];

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-night";
        theme_background = false;
      };
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "tokyonight_night";
      };
      themes = {
        tokyonight_night = {
          src = ../../assets/themes;
          file = "tokyonight_night.tmTheme";
        };
      };
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        enter_accept = true;
        show_numeric_shortcuts = false;
        keymap_mode = "vim-insert";
      };
    };

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      historyWidget.fish.command = "";
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "vivaldi-stable.desktop" "brave-browser.desktop" ];
        "x-scheme-handler/http" = [ "vivaldi-stable.desktop" "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "vivaldi-stable.desktop" "brave-browser.desktop" ];
        "x-scheme-handler/about" = [ "vivaldi-stable.desktop" "brave-browser.desktop" ];
        "x-scheme-handler/unknown" = [ "vivaldi-stable.desktop" "brave-browser.desktop" ];
      };
    };

    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
