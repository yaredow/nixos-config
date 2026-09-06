{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Handled by NixOS system module (modules/desktop.nix)
    configType = "hyprlang";

    settings = {
      # Monitors
      monitor = [
        "eDP-1, preferred, auto, 2"
        ", preferred, auto, 1"
      ];

      # Variables & Programs
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "fuzzel";
      "$browser" = "firefox";

      # Autostart
      exec-once = [
        "nm-applet --indicator"
      ];

      # Environment
      env = [
        "XCURSOR_SIZE,24"
      ];

      # General
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      dwindle = {
        preserve_split = true;
      };

      # Decoration
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = false;
        };
      };

      # Animations (Fixed)
      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Input
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      # Keybindings
      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, Return, exec, $terminal"
        "$mod, Space, exec, $menu"
        "$mod, E, exec, $browser"

        "$mod, C, killactive"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"

        # Focus movement
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Screenshot
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      ]
      ++ (
        # Workspaces 1-10 keybindings
        builtins.concatLists (builtins.genList (i:
          let
            ws = i + 1;
            key = toString (if ws == 10 then 0 else ws);
          in [
            "$mod, ${key}, workspace, ${toString ws}"
            "$mod SHIFT, ${key}, movetoworkspace, ${toString ws}"
          ]
        ) 10)
      );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
}
