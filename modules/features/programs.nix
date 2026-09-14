{ self, ... }: {
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
      mpv
      yt-dlp
      btop
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
  };
}
