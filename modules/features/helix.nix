{ ... }:
{
  flake.homeModules.helix = { pkgs, lib, ... }: {
    programs.helix = {
      enable = true;
      defaultEditor = true;

      settings = {
        theme = "tokyonight";
        editor = {
          line-number = "relative";
          cursorline = true;
          auto-format = true;
          scroll-lines = 5;
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = lib.getExe pkgs.nixfmt;
          }
        ];
      };

      extraPackages = with pkgs; [
        nil
        nixfmt-rfc-style
      ];
    };
  };
}
