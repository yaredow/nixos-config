{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # Build tools for treesitter parsers & native plugins
      gcc
      gnumake
      tree-sitter

      # Search & CLI tools
      ripgrep
      fd
      git
      unzip
      wget
      curl

      # Language Servers & Formatters
      lua-language-server
      stylua
      gopls
      golangci-lint
      typescript-language-server
      prettierd
      eslint_d
      nil # Nix Language Server
      nixfmt # Official Nix formatter
    ];

    # Prevent Home Manager from writing an individual ~/.config/nvim/init.lua,
    # since we manage the entire directory via xdg.configFile."nvim"
    sideloadInitLua = true;
  };

  # Deploy the modular Neovim configuration as an out-of-store symlink.
  # This makes ~/.config/nvim point directly to ~/nixos-config/home/nvim,
  # keeping lazy-lock.json writable and allowing live edits without rebuilding.
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/nvim";
}
