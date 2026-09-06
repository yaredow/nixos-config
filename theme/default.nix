rec {
  name = "tokyonight";
  mode = "dark";

  colors = {
    # Base background surfaces
    base = "#1a1b26";
    dark = "#13141c";     # Omarchy dark_background
    darker = "#0e0e14";   # Omarchy darker_background
    crust = "#16161e";    # Mantle / Sidebar / Titlebar
    lighter = "#24283b";  # Omarchy lighter_background / Card

    # Surface & Selection
    surface0 = "#292e42"; # Omarchy selection
    surface1 = "#3b4261"; # Vibrant selection
    surface2 = "#414868"; # Muted / borders

    # Foregrounds
    text = "#c0caf5";     # Bright foreground / primary text
    subtext = "#a9b1d6";  # Regular body foreground
    overlay = "#565f89";  # Inactive / comments

    # Primary accent & UI roles
    accent = "#7aa2f7";   # Tokyo Night Blue
    selection = "#292e42";
    selection_alt = "#3b4261";
    muted = "#414868";

    # Palette
    blue = "#7aa2f7";
    cyan = "#7dcfff";
    cyan_dark = "#449dab";
    green = "#9ece6a";
    yellow = "#e0af68";
    orange = "#ff9e64";
    orange_dark = "#eb927b";
    red = "#f7768e";
    purple = "#bb9af7";
    magenta = "#ad8ee6";
  };

  helpers = rec {
    strip = hex: builtins.replaceStrings [ "#" ] [ "" ] hex;
    alpha = hex: a: "${strip hex}${a}";
    rgba = hex: a: "rgba(${hex}, ${toString a})";
  };

  fonts = {
    mono = "CaskaydiaCove Nerd Font";
    size = 11;
  };
}
