{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "CaskaydiaCove Nerd Font:size=11";
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
        background = "1a1b26dd";
        text = "c0caf5ff";
        prompt = "7aa2f7ff";
        placeholder = "565f89ff";
        input = "c0caf5ff";
        match = "7aa2f7ff";
        selection = "3b4261ee";
        selection-text = "c0caf5ff";
        selection-match = "7dcfffff";
        border = "7aa2f7ff";
        counter = "565f89ff";
      };

      border = {
        width = 2;
        radius = 12;
        selection-radius = 8;
      };
    };
  };
}
