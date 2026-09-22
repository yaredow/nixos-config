{ ... }: {
  flake.homeModules.neovim = { config, pkgs, lib, ... }: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;

      extraPackages = with pkgs; [
        gcc
        gnumake
        tree-sitter
        git
        curl
        unzip
        ripgrep
        fd
        fzf
        wl-clipboard
        lua-language-server
        nil
        nixd
        gopls
        delve
        vtsls
        typescript-language-server
        vscode-langservers-extracted
        yaml-language-server
        marksman
        bash-language-server
        stylua
        nixfmt
        gofumpt
        gotools
        golangci-lint
        prettier
        prettierd
        shfmt
      ];
    };

    xdg.configFile."nvim".source = ./nvim;
    xdg.configFile."nvim/init.lua".enable = lib.mkForce false;
  };
}
