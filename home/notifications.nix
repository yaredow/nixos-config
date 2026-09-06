{ pkgs, theme, ... }:
{
  home.packages = [ pkgs.libnotify ];

  services.swaync = {
    enable = true;

    settings = {
      "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "overlay";
      layer-shell = true;
      cssPriority = "user";
      control-center-margin-top = 6;
      control-center-margin-bottom = 6;
      control-center-margin-right = 6;
      control-center-margin-left = 0;
      control-center-width = 380;
      control-center-height = 600;
      fit-to-screen = false;
      notification-window-width = 380;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      text-empty = "No Notifications";

      widgets = [
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        mpris = {
          show-album-art = "always";
          loop-carousel = false;
        };
        notifications = {
          vexpand = true;
        };
      };
    };

    style = ''
      * {
        font-family: "${theme.fonts.mono}", "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
      }

      .control-center {
        background: alpha(${theme.colors.crust}, 0.85);
        border: 1px solid alpha(${theme.colors.surface2}, 0.35);
        border-radius: 8px;
        color: ${theme.colors.text};
        padding: 12px;
      }

      .control-center-list {
        background: transparent;
      }

      .control-center-list-placeholder {
        opacity: 0.5;
        color: ${theme.colors.overlay};
      }

      .floating-notifications {
        background: transparent;
      }

      .blank-window {
        background: transparent;
      }

      .notification-row {
        outline: none;
        margin: 4px 0;
      }

      .notification-row .notification-background {
        padding: 4px 0;
      }

      .notification-row .notification-background .notification {
        background: alpha(${theme.colors.surface0}, 0.75);
        border: 1px solid alpha(${theme.colors.surface2}, 0.35);
        border-radius: 8px;
        padding: 8px 12px;
        color: ${theme.colors.text};
        transition: all 0.15s ease-in-out;
      }

      .notification-row .notification-background .notification:hover {
        background: alpha(${theme.colors.surface1}, 0.85);
      }

      .notification-row .notification-background .notification.critical {
        border-color: ${theme.colors.red};
      }

      .notification-row .notification-background .notification .notification-default-action {
        background: transparent;
        border: none;
        color: ${theme.colors.text};
      }

      .notification .summary {
        font-size: 13px;
        font-weight: bold;
        color: ${theme.colors.accent};
      }

      .notification .body {
        font-size: 12px;
        color: ${theme.colors.text};
      }

      .notification .time {
        font-size: 11px;
        color: ${theme.colors.overlay};
        margin-right: 24px;
      }

      .close-button {
        background: alpha(${theme.colors.lighter}, 0.6);
        color: ${theme.colors.subtext};
        border-radius: 50%;
        border: none;
        box-shadow: none;
        min-width: 20px;
        min-height: 20px;
      }

      .close-button:hover {
        background: ${theme.colors.red};
        color: ${theme.colors.darker};
      }

      .widget-title {
        color: ${theme.colors.text};
        padding: 4px 0 8px 0;
      }

      .widget-title > label {
        font-size: 15px;
        font-weight: bold;
      }

      .widget-title > button {
        background: alpha(${theme.colors.surface0}, 0.8);
        color: ${theme.colors.subtext};
        border: 1px solid alpha(${theme.colors.surface2}, 0.35);
        border-radius: 6px;
        padding: 4px 10px;
        font-size: 11px;
      }

      .widget-title > button:hover {
        background: alpha(${theme.colors.surface1}, 0.9);
        color: ${theme.colors.accent};
      }

      .widget-dnd {
        background: alpha(${theme.colors.surface0}, 0.5);
        border: 1px solid alpha(${theme.colors.surface2}, 0.25);
        border-radius: 6px;
        padding: 8px 12px;
        margin: 6px 0;
      }

      .widget-dnd > label {
        font-size: 13px;
        color: ${theme.colors.text};
      }

      .widget-dnd switch {
        border-radius: 12px;
        background: alpha(${theme.colors.surface1}, 0.8);
        border: 1px solid alpha(${theme.colors.surface2}, 0.35);
      }

      .widget-dnd switch:checked {
        background: ${theme.colors.accent};
      }

      .widget-dnd switch slider {
        border-radius: 12px;
        background: ${theme.colors.text};
      }

      .widget-mpris {
        background: alpha(${theme.colors.surface0}, 0.5);
        border: 1px solid alpha(${theme.colors.surface2}, 0.25);
        border-radius: 6px;
        padding: 8px;
        margin: 6px 0;
      }

      .widget-mpris .widget-mpris-player {
        background: transparent;
        border-radius: 6px;
      }

      .widget-mpris .widget-mpris-title {
        font-size: 13px;
        font-weight: bold;
        color: ${theme.colors.text};
      }

      .widget-mpris .widget-mpris-subtitle {
        font-size: 12px;
        color: ${theme.colors.subtext};
      }

      .widget-mpris button {
        color: ${theme.colors.text};
        border-radius: 4px;
      }

      .widget-mpris button:hover {
        background: alpha(${theme.colors.surface1}, 0.8);
        color: ${theme.colors.accent};
      }
    '';
  };
}
