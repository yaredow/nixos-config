{ ... }:
{
  # 1. System level: enables Niri compositor, graphics, portals, and PAM
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri.enable = true;
  };

  # 2. User level: configures keybindings, layout, rules, and clipboard
  flake.homeModules.niri = { pkgs, ... }: {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    xdg.configFile."niri/config.kdl".text = ''
      prefer-no-csd
      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      input {
        keyboard {
          xkb {
            // Add custom keyboard layout here if needed
          }
        }
        touchpad {
          tap
          natural-scroll
        }
      }

      layout {
        gaps 12
        center-focused-column "never"

        default-column-width { proportion 0.5; }

        preset-column-widths {
          proportion 0.33333
          proportion 0.5
          proportion 0.66667
        }

        focus-ring {
          width 2
          active-color "#7aa2f7"   // Tokyo Night Blue
          inactive-color "#414868" // Tokyo Night Slate Gray
        }

        border {
          off
        }
      }

      // Automatically float utility & dialog windows
      window-rule {
        match app-id="^pavucontrol$"
        match app-id="^blueman-manager$"
        match title="^Open File$"
        match title="^Save File$"
        match title="^Confirm to replace files$"
        open-floating true
      }

      binds {
        // Cheatsheet
        Mod+Shift+Slash { show-hotkey-overlay; }

        // Terminal
        Mod+Return hotkey-overlay-title="Open Terminal" { spawn "alacritty"; }
        Mod+T hotkey-overlay-title="Open Terminal" { spawn "alacritty"; }

        // Window Controls
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }

        // Horizontal Navigation (Columns)
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+L     { focus-column-right; }

        // Vertical Navigation (Windows within a column)
        Mod+Up    { focus-window-up; }
        Mod+Down  { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+J     { focus-window-down; }

        // Moving windows
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+L     { move-column-right; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+K     { move-window-up; }
        Mod+Shift+J     { move-window-down; }

        // Workspaces (Vertical)
        Mod+Ctrl+Down  { focus-workspace-down; }
        Mod+Ctrl+Up    { focus-workspace-up; }
        Mod+Ctrl+J     { focus-workspace-down; }
        Mod+Ctrl+K     { focus-workspace-up; }
        Mod+Ctrl+Shift+Down { move-window-to-workspace-down; }
        Mod+Ctrl+Shift+Up   { move-window-to-workspace-up; }

        // Direct Workspace Jump (1-9)
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Sizing & Fullscreen
        Mod+R { switch-preset-column-width; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C { center-column; }

        // Screenshots
        Print { screenshot; }
        Mod+Shift+S { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        // Volume & Media Keys (via PipeWire)
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
        XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      }
    '';
  };
}
