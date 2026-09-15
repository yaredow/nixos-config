{ self, inputs, ... }: {
  flake.homeModules.programs = { pkgs, ... }: {
    home.pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    home.packages = with pkgs; [
      fastfetch
      bat
      ripgrep
      fd
      wget
      unzip
      qbittorrent
      yazi
      mpv
      yt-dlp
      btop
      inputs.helium-browser.packages.${pkgs.system}.default
    ];

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

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      presets = [ "nerd-font-symbols" ];
    };

    programs.btop.enable = true;

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "helium-browser.desktop" ];
        "x-scheme-handler/http" = [ "helium-browser.desktop" ];
        "x-scheme-handler/https" = [ "helium-browser.desktop" ];
        "x-scheme-handler/about" = [ "helium-browser.desktop" ];
        "x-scheme-handler/unknown" = [ "helium-browser.desktop" ];
      };
    };
    programs.direnv = { enable = true; enableFishIntegration = true; };
  };
}
