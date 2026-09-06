{ pkgs, theme, ... }:
let
  swayosdStyle = pkgs.writeText "swayosd-style.css" ''
    window#osd {
      border-radius: 999px;
      border: 1px solid alpha(${theme.colors.surface2}, 0.35);
      background: alpha(${theme.colors.crust}, 0.85);
      padding: 4px;
    }

    window#osd #container {
      margin: 14px 18px;
    }

    window#osd image,
    window#osd label {
      color: ${theme.colors.text};
      font-family: "${theme.fonts.mono}", "JetBrainsMono Nerd Font", monospace;
    }

    window#osd progressbar:disabled,
    window#osd image:disabled {
      opacity: 0.5;
    }

    window#osd progressbar,
    window#osd segmentedprogress {
      min-height: 8px;
      border-radius: 999px;
      background: transparent;
      border: none;
    }

    window#osd trough,
    window#osd segment {
      min-height: inherit;
      border-radius: inherit;
      border: none;
      background: alpha(${theme.colors.surface0}, 0.8);
    }

    window#osd progress,
    window#osd segment.active {
      min-height: inherit;
      border-radius: inherit;
      border: none;
      background: ${theme.colors.accent};
    }

    window#osd segment {
      margin-left: 6px;
    }

    window#osd segment:first-child {
      margin-left: 0;
    }
  '';
in
{
  services.swayosd = {
    enable = true;
    stylePath = swayosdStyle;
  };
}
