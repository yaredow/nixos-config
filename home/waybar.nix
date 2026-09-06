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
          "idle_inhibitor"
          "clock"
        ];

        modules-right = [
          "pulseaudio"
          "network"
          "bluetooth"
          "cpu"
          "battery"
          "custom/notification"
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
            "10" = "0";
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

        clock = {
          format = "{:%A %H:%M}";
          format-alt = "{:%A %H:%M:%S}";
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

        pulseaudio = {
          format = "{icon}";
          format-muted = "";
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

        network = {
          format-wifi = "{icon}";
          format-ethernet = "󰈀";
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
          on-click = "${pkgs.kitty}/bin/kitty --title impala -e ${pkgs.impala}/bin/impala";
        };

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          format-connected-battery = "󰂱";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "${pkgs.kitty}/bin/kitty --title bluetui -e ${pkgs.bluetui}/bin/bluetui";
          on-click-right = "rfkill toggle bluetooth";
        };

        cpu = {
          format = "󰍛";
          tooltip = true;
          tooltip-format = "CPU: {usage}%";
          on-click = "${pkgs.kitty}/bin/kitty --title btop -e ${pkgs.btop}/bin/btop";
        };

        battery = {
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{icon}";
          format-charging = "{icon}";
          format-plugged = "󰂅";
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
          tooltip-format = "{capacity}% · {timeTo} · Health: {health}%";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "󱅫";
            none = "󰂚";
            dnd-notification = "󰂛";
            dnd-none = "󰂛";
            inhibited-notification = "󱅫";
            inhibited-none = "󰂚";
            dnd-inhibited-notification = "󰂛";
            dnd-inhibited-none = "󰂛";
          };
          return-type = "json";
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          escape = true;
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
        font-size: 13px;
        min-height: 0;
        box-shadow: none;
        text-shadow: none;
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
        box-shadow: none;
        text-shadow: none;
        background-image: none;
        border: none;
        padding: 0 6px;
        color: ${theme.colors.text};
        background: transparent;
        border-radius: 4px;
        opacity: 1;
        transition: all 0.15s ease-in-out;
      }

      #workspaces button.empty {
        box-shadow: none;
        text-shadow: none;
        background-image: none;
        border: none;
        color: ${theme.colors.subtext};
        opacity: 0.65;
      }

      #workspaces button.active {
        box-shadow: none;
        text-shadow: none;
        background-image: none;
        border: none;
        color: ${theme.colors.accent};
        opacity: 1;
        font-weight: bold;
      }

      #workspaces button:hover {
        box-shadow: none;
        text-shadow: none;
        background-image: none;
        border: none;
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
        font-size: 12px;
      }

      #idle_inhibitor {
        padding: 0 6px;
        margin: 0 2px;
        color: ${theme.colors.overlay};
        opacity: 0.5;
        border-radius: 4px;
        transition: all 0.15s ease-in-out;
      }

      #idle_inhibitor.activated {
        color: ${theme.colors.accent};
        opacity: 1;
      }

      #idle_inhibitor:hover {
        background: alpha(${theme.colors.surface0}, 0.6);
      }

      #clock {
        font-weight: 600;
        padding: 0 8px;
        color: ${theme.colors.text};
        border-radius: 4px;
        font-size: 12px;
      }

      #clock:hover {
        background: alpha(${theme.colors.surface0}, 0.6);
      }

      #pulseaudio,
      #network,
      #bluetooth,
      #cpu,
      #battery,
      #custom-notification,
      #tray,
      #custom-power {
        padding: 0 8px;
        margin: 0 1px;
        color: ${theme.colors.text};
        border-radius: 4px;
        transition: all 0.15s ease-in-out;
      }

      #pulseaudio:hover,
      #network:hover,
      #bluetooth:hover,
      #cpu:hover,
      #battery:hover,
      #custom-notification:hover {
        background: alpha(${theme.colors.surface0}, 0.6);
      }

      #custom-notification.notification {
        color: ${theme.colors.accent};
      }

      #custom-notification.dnd {
        color: ${theme.colors.overlay};
        opacity: 0.5;
      }

      #custom-power:hover {
        color: ${theme.colors.red};
        background: alpha(${theme.colors.surface0}, 0.6);
      }

      #pulseaudio.muted {
        color: ${theme.colors.overlay};
        opacity: 0.5;
      }

      #network.disconnected {
        color: ${theme.colors.overlay};
        opacity: 0.5;
      }

      #bluetooth.disabled {
        color: ${theme.colors.overlay};
        opacity: 0.5;
      }

      #battery.warning:not(.charging) {
        color: ${theme.colors.yellow};
      }

      #battery.critical:not(.charging) {
        color: ${theme.colors.red};
      }

      #custom-power {
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
