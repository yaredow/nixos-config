{ pkgs, theme, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "${theme.fonts.mono}:size=${toString theme.fonts.size}";
        prompt = "\"❯ \"";
        icon-theme = "Adwaita";
        terminal = "kitty";
        width = 38;
        lines = 10;
        horizontal-pad = 20;
        vertical-pad = 16;
        inner-pad = 8;
        line-height = 24;
        image-size-ratio = 0.5;
        layer = "overlay";
        exit-on-keyboard-focus-loss = true;
      };

      colors = {
        background = theme.helpers.alpha theme.colors.base "dd";
        text = theme.helpers.alpha theme.colors.text "ff";
        prompt = theme.helpers.alpha theme.colors.accent "ff";
        placeholder = theme.helpers.alpha theme.colors.overlay "ff";
        input = theme.helpers.alpha theme.colors.text "ff";
        match = theme.helpers.alpha theme.colors.accent "ff";
        selection = theme.helpers.alpha theme.colors.selection "ee";
        selection-text = theme.helpers.alpha theme.colors.text "ff";
        selection-match = theme.helpers.alpha theme.colors.cyan "ff";
        border = theme.helpers.alpha theme.colors.accent "ff";
        counter = theme.helpers.alpha theme.colors.overlay "ff";
      };

      border = {
        width = 2;
        radius = 12;
        selection-radius = 8;
      };
    };
  };
}
