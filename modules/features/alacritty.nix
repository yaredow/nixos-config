{ ... }:
{
  flake.homeModules.alacritty = { ... }: {
    programs.alacritty = {
      enable = true;

      settings = {
        scrolling = {
          multiplier = 5;
        };

        window = {
          opacity = 0.95;
          decorations = "None";
          padding = {
            x = 10;
            y = 10;
          };
        };

        font = {
          size = 9.5;
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
        };

        colors = {
          primary = {
            background = "#15161e";
            foreground = "#c0caf5";
          };
          normal = {
            black = "#15161e";
            red = "#f7768e";
            green = "#9ece6a";
            yellow = "#e0af68";
            blue = "#7aa2f7";
            magenta = "#bb9af7";
            cyan = "#7dcfff";
            white = "#a9b1d6";
          };
          bright = {
            black = "#414868";
            red = "#f7768e";
            green = "#9ece6a";
            yellow = "#e0af68";
            blue = "#7aa2f7";
            magenta = "#bb9af7";
            cyan = "#7dcfff";
            white = "#c0caf5";
          };
        };
      };
    };
  };
}
