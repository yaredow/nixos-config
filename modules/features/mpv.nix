{ ... }: {
  flake.homeModules.mpv = { pkgs, ... }:
    let
      tokyoNightOscModern = pkgs.mpvScripts.mpv-osc-modern.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace modern.lua \
            --replace-fail "1c&HE39C42&" "1c&HF7A27A&" \
            --replace-fail "VolumebarFg = '{\\\\blur1\\\\bord1\\\\1c&HFFFFFF&}'" "VolumebarFg = '{\\\\blur1\\\\bord1\\\\1c&HF7A27A&}'" \
            --replace-fail "Ctrl1 = '{\\\\blur0\\\\bord0\\\\1c&HFFFFFF&\\\\3c&HFFFFFF&" "Ctrl1 = '{\\\\blur0\\\\bord0\\\\1c&HF7A27A&\\\\3c&HF7A27A&" \
            --replace-fail "elementDown = '{\\\\1c&H999999&}'" "elementDown = '{\\\\1c&HF7A27A&}'" \
            --replace-fail "1c&HFFFFFF&" "1c&HF5CAC0&" \
            --replace-fail "3c&HFFFFFF&" "3c&HF5CAC0&" \
            --replace-fail "1c&H999999&" "1c&H895F56&" \
            --replace-fail "1c&H000000&\\\\3c&H000000&" "1c&H261B1A&\\\\3c&H261B1A&"
        '';
      });
    in
    {
      programs.mpv = {
        enable = true;
        scripts = [
          tokyoNightOscModern
          pkgs.mpvScripts.mpris
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
          osc = {
            scalewindowed = 2.0;
            scalefullscreen = 2.0;
            vidscale = false;
          };
        };
      };
    };
}
