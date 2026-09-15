{ self, ... }: {
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
    ];

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      settings = {
        enter_accept = true;
        show_numeric_shortcuts = false;
        keymap_mode = "vim-insert";
      };
    };

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      git = true;
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      historyWidget.fish.command = "";
      historyWidget.zsh.command = "";
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      presets = [ "nerd-font-symbols" ];
    };

    programs.btop.enable = true;\n    programs.direnv = { enable = true; enableZshIntegration = true; };
  };
}
