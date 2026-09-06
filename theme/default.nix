rec {
  name = "tokyonight";
  mode = "dark";

  colors = {
    base = "#1a1b26";
    dark = "#13141c";
    darker = "#0e0e14";
    crust = "#16161e";
    lighter = "#24283b";

    surface0 = "#292e42";
    surface1 = "#3b4261";
    surface2 = "#414868";

    text = "#c0caf5";
    subtext = "#a9b1d6";
    overlay = "#565f89";

    accent = "#7aa2f7";
    selection = "#292e42";
    selection_alt = "#3b4261";
    muted = "#414868";

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
