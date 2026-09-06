{ theme, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "${theme.wallpaper}";
          fit_mode = "cover";
        }
      ];
    };
  };
}
