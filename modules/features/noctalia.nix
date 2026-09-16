{ inputs, ... }:
{
  flake.nixosModules.noctalia = { ... }: {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
    security.pam.services.noctalia = {};
  };

  flake.homeModules.noctalia = { pkgs, ... }:
    let
      noctaliaPkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      wallpaperPath = "${noctaliaPkg}/share/noctalia/assets/noctalia-wallpaper.png";
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;
        settings = {
          idle = {
            behavior.screen-off.enabled = false;
            behavior.lock-and-suspend.enabled = false;
          };

            lockscreen = {
              enabled = true;
              blurred_desktop = true;
              blur_intensity = 0.7;
            };
          config_version = 14;

          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Tokyo-Night";
            wallpaper_scheme = "m3-content";
          };

          wallpaper = {
            enabled = true;
            fill_mode = "crop";
            default.path = wallpaperPath;
            monitors."Virtual-1" = wallpaperPath;
          };

          shell = {
            font_family = "CaskaydiaCove Nerd Font";
            animation = {
              enabled = false;
              speed = 1.0;
            };
          };

          bar = {
            order = [ "default" ];
            "default" = {
              enabled = true;
              position = "top";
              layer = "top";
              reserve_space = true;
              thickness = 30;
              margin_edge = 0;
              margin_ends = 0;
              radius = 0;
              background_opacity = 1.0;
              border_width = 0.0;
              capsule = true;
            capsule_radius = 15;
            capsule_padding = 4;
              widget_spacing = 14;
              padding = 16;
              font_family = "CaskaydiaCove Nerd Font";
              font_weight = 500;

              start = [
                "launcher"
                "workspaces"
                "active_window"
              ];
              center = [ "clock" ];
              end = [
                "media"
                "tray"
                "network"
                "volume"
                "battery"
                "control-center"
                "session"
              ];
            };
          };

          widget = {
            launcher = {
              custom_image = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              custom_image_colorize = true;
              icon_color = "primary";
            };

            workspaces = {
              style = "minimal";
              show_icons = false;
              show_labels = true;
              label_source = "id";
              labels_only_when_occupied = false;
              hide_when_empty = false;
              focused_color = "primary";
              occupied_color = "on_surface";
              empty_color = "outline";
            };

            active_window = {
              icon_size = 14.0;
              max_length = 260.0;
              show_empty_label = false;
            };

            clock = {
              format = "󰃭 {:%a %d %b}    {:%H:%M}";
              tooltip_format = "%A, %d %B %Y";
            };

            media = {
              hide_when_no_media = true;
              show_progress = true;
              max_length = 180.0;
            };

            notifications = {
              hide_when_no_unread = true;
            };

            network = {
              show_label = false;
            };

            volume = {
              show_label = true;
              custom_image = "/run/current-system/sw/share/icons/Papirus/24x24/symbolic/status/audio-volume-high-symbolic.svg";
              custom_image_colorize = true;
            };

            battery = {
              show_label = true;
              hide_when_full = false;
            };

            control-center = {
              custom_image = "/run/current-system/sw/share/icons/Papirus/24x24/symbolic/categories/preferences-system-symbolic.svg";
              custom_image_colorize = true;
            };

            session = {
              custom_image = "/run/current-system/sw/share/icons/Papirus/24x24/symbolic/actions/system-shutdown-symbolic.svg";
              custom_image_colorize = true;
              color = "error";
            };
          };
        };
      };
    };
}
