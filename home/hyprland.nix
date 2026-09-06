{ pkgs, theme, ... }:
{
  # XDG desktop portal configuration
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Handled by NixOS system module (modules/desktop.nix)
    configType = "lua";

    extraConfig = ''
      local theme = {
          active1 = "rgba(${theme.helpers.strip theme.colors.accent}ee)",
          active2 = "rgba(${theme.helpers.strip theme.colors.purple}ee)",
          inactive = "rgba(${theme.helpers.strip theme.colors.overlay}aa)",
      }

      -----------------------
      ---- LOOK AND FEEL ----
      -----------------------
      hl.config({
          general = {
              gaps_in = 4,
              gaps_out = 6,
              border_size = 2,
              col = {
                  active_border = { colors = { theme.active1, theme.active2 }, angle = 45 },
                  inactive_border = theme.inactive,
              },
              resize_on_border = false,
              allow_tearing = false,
              layout = "dwindle",
          },

          decoration = {
              rounding = 4,
              rounding_power = 2,
              active_opacity = 1.0,
              inactive_opacity = 0.95,
              shadow = {
                  enabled = true,
                  range = 4,
                  render_power = 3,
                  color = 0xee11111b,
              },
              blur = {
                  enabled = true,
                  size = 3,
                  passes = 1,
                  vibrancy = 0.1696,
              },
          },

          dwindle = {
              preserve_split = true,
          },

          misc = {
              force_default_wallpaper = 2,
              disable_hyprland_logo = true,
          },

          input = {
              kb_layout = "us",
              repeat_rate = 25,
              repeat_delay = 300,
              follow_mouse = 1,
              sensitivity = 0,
              touchpad = {
                  natural_scroll = true,
                  scroll_factor = 2,
              },
          },

          cursor = {
              hide_on_key_press = true,
              warp_on_change_workspace = 1,
          },

          animations = {
              enabled = true,
          },
      })

      -- Monitors
      hl.monitor({
          output = "eDP-1",
          mode = "preferred",
          position = "auto",
          scale = "2",
      })
      hl.monitor({
          output = "",
          mode = "preferred",
          position = "auto",
          scale = "1",
      })

      -- Touchpad gesture (3-finger workspace swipe)
      hl.gesture({
          fingers = 3,
          direction = "horizontal",
          action = "workspace",
      })

      -- Autostart
      hl.on("hyprland.start", function()
          hl.exec_cmd("nm-applet --indicator")
          hl.exec_cmd("hyprctl setcursor Adwaita 24")
      end)

      -- Environment variables
      hl.env("XCURSOR_THEME", "Adwaita")
      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_THEME", "Adwaita")
      hl.env("HYPRCURSOR_SIZE", "24")
      hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
      hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
      hl.env("GDK_BACKEND", "wayland,x11")
      hl.env("MOZ_ENABLE_WAYLAND", "1")

      -----------------------------------------
      ---- CURVES & ANIMATIONS (ARCH SETUP) ----
      -----------------------------------------
      hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
      hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
      hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
      hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
      hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
      hl.curve("easy", { type = "spring", mass = 1, stiffness = 300, dampening = 32 })

      hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
      hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
      hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
      hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
      hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
      hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
      hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
      hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
      hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

      ----------------------
      ---- KEYBINDINGS -----
      ----------------------
      local mainMod = "ALT"
      local secondMod = "ALT + SHIFT"

      local terminal = "kitty"
      local menu = "fuzzel"
      local browser = "firefox"
      local fileManager = "nautilus --new-window"

      -- App shortcuts
      hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
      hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
      hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
      hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
      hl.bind(secondMod .. " + F", hl.dsp.exec_cmd(fileManager))

      -- Window operations
      hl.bind(mainMod .. " + Q", hl.dsp.window.close())
      hl.bind(mainMod .. " + C", hl.dsp.window.close())
      hl.bind(secondMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

      -- Focus movement
      hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
      hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

      -- Move active window (hjkl)
      hl.bind(secondMod .. " + h", hl.dsp.window.move({ direction = "left" }))
      hl.bind(secondMod .. " + l", hl.dsp.window.move({ direction = "right" }))
      hl.bind(secondMod .. " + k", hl.dsp.window.move({ direction = "up" }))
      hl.bind(secondMod .. " + j", hl.dsp.window.move({ direction = "down" }))

      -- Resize active window
      hl.bind(secondMod .. " + equal", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
      hl.bind(secondMod .. " + minus", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })

      -- Workspaces 1-10
      for i = 1, 10 do
          local key = i % 10
          hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind(secondMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      -- Special workspace (Scratchpad magic)
      hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
      hl.bind(secondMod .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))

      -- Workspace cycling
      hl.bind("ALT + CTRL + h", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind("ALT + CTRL + l", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      -- Mouse dragging & resizing
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Fn Keys (Audio & Brightness)
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

      -- Media keys
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

      -- Screenshot
      hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

      --------------------------------
      ---- WINDOWS AND WORKSPACES ----
      --------------------------------
      hl.window_rule({
          name = "suppress-maximize-events",
          match = { class = ".*" },
          suppress_event = "maximize",
      })

      hl.window_rule({
          name = "fix-xwayland-drags",
          match = {
              class = "^$",
              title = "^$",
              xwayland = true,
              float = true,
              fullscreen = false,
              pin = false,
          },
          no_focus = true,
      })

      hl.window_rule({
          name = "float-btop",
          match = { title = "^btop$" },
          float = true,
          center = true,
      })

      hl.window_rule({
          name = "float-bluetui",
          match = { title = "^bluetui$" },
          float = true,
          center = true,
      })

      hl.window_rule({
          name = "float-impala",
          match = { title = "^impala$" },
          float = true,
          center = true,
      })

      hl.layer_rule({
          name = "fuzzel-blur",
          match = { namespace = "fuzzel" },
          blur = true,
          ignore_alpha = 0.5,
      })

      hl.layer_rule({
          name = "waybar-blur",
          match = { namespace = "waybar" },
          blur = true,
          ignore_alpha = 0.5,
      })
    '';
  };
}
