{ ... }: {
  flake.homeModules.mpv = { pkgs, ... }: {
    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        modernx-zydezu
        mpris
      ];
      config = {
        osc = false;
        border = false;
        save-position-on-quit = true;

        sub-auto = "fuzzy";
        sub-file-paths = "sub:subs:subtitles:Subtitles:Sub:Subs";
        slang = "en,eng,enUS,en-US";
        alang = "en,eng,ja,jp,jpn";

        sub-font = "sans-serif";
        sub-font-size = 36;
        sub-border-size = 2.5;
        sub-shadow-offset = 1;
        sub-pos = 95;
        sub-color = "#c0caf5";
        sub-border-color = "#1a1b26";

        osd-font = "sans-serif";
        osd-font-size = 26;
        osd-border-size = 2.0;
        osd-scale = 1;
        osd-color = "#c0caf5";
        osd-border-color = "#1a1b26";

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
        modernx = {
          scale_windowed = 2.0;
          scale_fullscreen = 2.0;
          vid_scale = false;
          osc_color = "#1a1b26";
          seekbarfg_color = "#7aa2f7";
          seekbarbg_color = "#24283b";
          seekbar_cache_color = "#414868";
          title_color = "#c0caf5";
          time_color = "#a9b1d6";
          playpause_color = "#7aa2f7";
          middle_buttons_color = "#c0caf5";
          side_buttons_color = "#c0caf5";
          window_title_color = "#c0caf5";
          window_controls_color = "#c0caf5";
          window_controls_minmax_hover = "#7aa2f7";
          window_controls_close_hover = "#f7768e";
        };
      };
    };
  };
}
