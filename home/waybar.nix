{ pkgs, theme, ... }:
let
  powerMenu = pkgs.writeShellScript "power-menu" ''
    chosen=$(printf "󰐥  Shutdown\n󰜉  Reboot\n󰒲  Suspend\n󰍃  Log Out" | ${pkgs.fuzzel}/bin/fuzzel --dmenu -p "Power: ")
    case "$chosen" in
      *Shutdown) systemctl poweroff ;;
      *Reboot) systemctl reboot ;;
      *Suspend) systemctl suspend ;;
      *"Log Out") hyprctl dispatch exit ;;
    esac
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "custom/menu"
          "hyprland/workspaces"
          "mpris"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "backlight"
          "network"
          "bluetooth"
          "cpu"
          "battery"
          "tray"
          "custom/power"
        ];

        "custom/menu" = {
          format = "";
          tooltip = false;
          on-click = "${pkgs.fuzzel}/bin/fuzzel";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "󱓻";
            default = "{name}";
          };
          persistent-workspaces = {
            "*" = 5;
          };
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{player_icon} <i>{dynamic}</i>";
          player-icons = {
            default = "󰝚";
            spotify = "󰓇";
            firefox = "󰈹";
            chromium = "󰈹";
            mpv = "󰈸";
          };
          max-length = 35;
          tooltip = true;
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          format-alt = "{:%Y-%m-%d  %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='${theme.colors.accent}'><b>{}</b></span>";
              days = "<span color='${theme.colors.text}'><b>{}</b></span>";
              weeks = "<span color='${theme.colors.overlay}'><b>W{}</b></span>";
              weekdays = "<span color='${theme.colors.yellow}'><b>{}</b></span>";
              today = "<span color='${theme.colors.red}'><b><u>{}</u></b></span>";
            };
          };
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰅶";
          };
          tooltip = true;
          tooltip-format-activated = "Keep awake (on)";
          tooltip-format-deactivated = "Keep awake (off)";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " {volume}%";
          format-icons = {
            headphone = "󰋋";
            default = [
              ""
              ""
              ""
            ];
          };
          scroll-step = 5;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
          tooltip-format = "{desc} · {volume}%";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
          on-scroll-up = "brightnessctl set 5%+";
          on-scroll-down = "brightnessctl set 5%-";
        };

        network = {
          format-wifi = "{icon} {signalStrength}%";
          format-ethernet = "󰈀 {ipaddr}";
          format-disconnected = "󰤮";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          tooltip-format-wifi = "{essid} ({signalStrength}%)\nIP: {ipaddr}\nGW: {gwaddr}";
          tooltip-format-ethernet = "{ifname}\nIP: {ipaddr}";
          tooltip-format-disconnected = "Disconnected";
          on-click = "kitty --title impala -e impala";
        };

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱 {device_alias}";
          format-connected-battery = "󰂱 {device_alias} ({device_battery_percentage}%)";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "kitty --title bluetui -e bluetui";
          on-click-right = "rfkill toggle bluetooth";
        };

        cpu = {
          format = "󰍛 {usage}%";
          tooltip = true;
          on-click = "kitty --title btop -e btop";
        };

        battery = {
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{icon} {capacity}%";
          format-charging = "{icon} {capacity}%";
          format-plugged = "󰂅 {capacity}%";
          format-icons = {
            default = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            charging = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
          };
          tooltip-format = "{timeTo} · Health: {health}%";
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "${powerMenu}";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "${theme.fonts.mono}", "JetBrainsMono Nerd Font", monospace;
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background: alpha(${theme.colors.crust}, 0.85);
        border-bottom: 1px solid alpha(${theme.colors.surface2}, 0.35);
        color: ${theme.colors.text};
      }

      #custom-menu {
        color: ${theme.colors.accent};
        padding: 0 10px;
        font-size: 15px;
      }

      #custom-menu:hover {
        background: alpha(${theme.colors.surface0}, 0.6);
        border-radius: 4px;
      }

      #workspaces {
        margin: 0 4px;
      }

      #workspaces button {
        padding: 0 6px;
        color: ${theme.colors.text};
        background: transparent;
        border-radius: 4px;
        opacity: 1;
        transition: all 0.15s ease-in-out;
      }

      #workspaces button.empty {
        color: ${theme.colors.overlay};
        opacity: 0.45;
      }

      #workspaces button.active {
        color: ${theme.colors.accent};
        opacity: 1;
        font-weight: bold;
      }

      #workspaces button:hover {
        opacity: 1;
        color: ${theme.colors.accent};
        background: alpha(${theme.colors.surface0}, 0.6);
      }

      #mpris {
        padding: 0 8px;
        margin: 0 4px;
        color: ${theme.colors.purple};
        background: alpha(${theme.colors.lighter}, 0.4);
        border-radius: 4px;
      }

      #clock {
        font-weight: 600;
        padding: 0 8px;
        color: ${theme.colors.text};
      }

      #idle_inhibitor,
      #pulseaudio,
      #backlight,
      #network,
      #bluetooth,
      #cpu,
      #battery,
      #tray,
      #custom-power {
        padding: 0 7px;
        margin: 0 1px;
        color: ${theme.colors.text};
        border-radius: 4px;
        transition: all 0.15s ease-in-out;
      }

      #idle_inhibitor:hover,
      #pulseaudio:hover,
      #backlight:hover,
      #network:hover,
      #bluetooth:hover,
      #cpu:hover,
      #battery:hover,
      #custom-power:hover {
        background: alpha(${theme.colors.surface0}, 0.6);
      }

      #idle_inhibitor {
        color: ${theme.colors.overlay};
        opacity: 0.5;
      }

      #idle_inhibitor.activated {
        color: ${theme.colors.accent};
        opacity: 1;
      }

      #pulseaudio.muted {
        color: ${theme.colors.overlay};
      }

      #network.disconnected {
        color: ${theme.colors.red};
      }

      #bluetooth.disabled {
        color: ${theme.colors.overlay};
      }

      #bluetooth.connected {
        color: ${theme.colors.blue};
      }

      #cpu {
        color: ${theme.colors.cyan};
      }

      #battery.charging,
      #battery.plugged {
        color: ${theme.colors.cyan};
      }

      #battery.warning:not(.charging) {
        color: ${theme.colors.yellow};
      }

      #battery.critical:not(.charging) {
        color: ${theme.colors.red};
      }

      #custom-power {
        color: ${theme.colors.red};
        padding-right: 10px;
      }

      tooltip {
        background: ${theme.colors.crust};
        border: 1px solid ${theme.colors.surface2};
        border-radius: 6px;
        padding: 6px 10px;
      }

      tooltip label {
        color: ${theme.colors.text};
        font-size: 12px;
      }
    '';
  };
}
