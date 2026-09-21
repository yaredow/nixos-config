{ ... }: {
  flake.homeModules.mpv = { pkgs, ... }: {
    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        mpv-osc-modern
        mpris
      ];
      config = {
        # General Window & Playback Settings
        osc = false;
        border = false;
        save-position-on-quit = true;

        # Subtitle Autoloading & Preferences
        sub-auto = "fuzzy";
        sub-file-paths = "sub:subs:subtitles:Subtitles:Sub:Subs";
        slang = "en,eng,enUS,en-US";
        alang = "en,eng,ja,jp,jpn";

        # Subtitle Appearance & Styling
        sub-font = "sans-serif";
        sub-font-size = 40;
        sub-border-size = 2.5;
        sub-shadow-offset = 1;
        sub-pos = 95;

        # HiDPI Scaling & Appropriate Floating Sizing
        hidpi-window-scale = true;
        osd-scale = 2;
        sub-scale = 1.2;
        autofit = "75%x75%";
        autofit-larger = "85%x85%";
        autofit-smaller = "50%x50%";
        geometry = "50%:50%";
      };
      bindings = {
        z = "add sub-delay -0.1";
        Z = "add sub-delay +0.1";
        r = "add sub-pos -1";
        t = "add sub-pos +1";
        v = "cycle sub-visibility";
      };
      scriptOpts = {
        osc = {
          scalewindowed = 2.5;
          scalefullscreen = 2.5;
          vidscale = false;
          accent = "#7aa2f7";
          fg = "#c0caf5";
          bg = "#1a1b26";
          bar_bg = "#24283b";
          down = "#565f89";
        };
      };
    };
  };
}
