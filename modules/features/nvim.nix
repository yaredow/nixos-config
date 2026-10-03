{ ... }:
let
  nvimModule =
    { config, pkgs, lib, ... }:
    {
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
          sqlfluff
        ];
      };

      xdg.configFile."nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nvim-config";
      xdg.configFile."nvim/init.lua".enable = lib.mkForce false;
    };
in
{
  flake.homeModules.nvim = nvimModule;
  flake.homeModules.neovim = nvimModule;
}
