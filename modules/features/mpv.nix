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
        sub-font-size = 36;
        sub-border-size = 2.5;
        sub-shadow-offset = 1;
        sub-pos = 95;

        # OSD Appearance (Volume, Subtitle & Notification Popups)
        osd-font = "sans-serif";
        osd-font-size = 26;
        osd-border-size = 2.0;
        osd-scale = 1;

        # Appropriate Floating Sizing & HiDPI Content Scaling (2x for 3.2k display)
        sub-scale = 1.0;
        autofit = "60%x60%";
        autofit-larger = "70%x70%";
        autofit-smaller = "35%x35%";
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
          scalewindowed = 2.0;
          scalefullscreen = 2.0;
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
