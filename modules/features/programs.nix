{ self, inputs, ... }: {
  # System level configuration for desktop integration services
  flake.nixosModules.programs = { pkgs, ... }: {
    # File manager integration (trash, network shares, USB mounting, and thumbnails)
    services.gvfs.enable = true;
    services.tumbler.enable = true;
  };

  flake.homeModules.programs = { pkgs, ... }: {
    home.packages = with pkgs; [
      fastfetch
      bat
      ripgrep
      fd
      wget
      unzip
      qbittorrent
      yazi
      yt-dlp
      btop
      cliamp
      telegram-desktop
      nautilus
      loupe
      evince
      gnumake
      docker-compose

      # Go development
      go
      gopls
      delve
      golangci-lint
      golangci-lint-langserver
      gofumpt

      # JavaScript / TypeScript development
      bun
      typescript
      typescript-language-server
    ];

    programs.brave = {
      enable = true;
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,TouchpadOverscrollHistoryNavigation"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
      ];
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

    programs.btop.enable = true;

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "brave-browser.desktop" ];
        "x-scheme-handler/http" = [ "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "brave-browser.desktop" ];
        "x-scheme-handler/about" = [ "brave-browser.desktop" ];
        "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
      };
    };
    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
