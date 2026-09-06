{ pkgs, ... }:
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
  };

  # Deploy the modular Neovim configuration to ~/.config/nvim
  xdg.configFile."nvim".source = ./nvim;
}
