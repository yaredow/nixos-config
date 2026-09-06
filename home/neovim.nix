{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      gcc
      gnumake
      tree-sitter

      ripgrep
      fd
      git
      unzip
      wget
      curl

      # Runtime environments
      nodejs
      go

      # Language Servers & Formatters
      lua-language-server
      stylua
      gopls
      golangci-lint
      typescript-language-server
      prettierd
      prettier
      eslint_d
      nil
      nixfmt
    ];

    sideloadInitLua = true;
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/nvim";
}
