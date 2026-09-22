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
        checkConfig = false;
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
            font_family = "JetBrainsMono Nerd Font";
            disable_mipmaps = true;  # fixes blurry downscaled icons on HiDPI
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
              thickness = 32;
              margin_edge = 0;
              margin_ends = 0;
              radius = 0;
              background_opacity = 1.0;
              border_width = 0.0;
              shadow = false;
              capsule = true;
              capsule_fill = "surface_variant";
              capsule_opacity = 0.85;
              capsule_padding = 6;
              widget_spacing = 6;
              padding = 8;
              font_family = "JetBrainsMono Nerd Font";
              font_weight = 500;
              font_scale = 1.0;

              start = [
                "launcher"
                "workspaces"
                "media"
              ];
              center = [ "clock" ];
              end = [
                "privacy"
                "tray"
                "notifications"
                "network"
                "bluetooth"
                "battery"
                "volume"
                "mic"
              ];

              dead_zone.actions = {
                left = "panel-toggle launcher";
                right = "panel-toggle control-center";
              };
            };
          };

          widget = {
            launcher = {
              custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              custom_image_colorize = true;
              icon_color = "primary";
            };

            media = {
              hide_when_no_media = true;
              show_progress = false;
              max_length = 180.0;
              font_family = "JetBrainsMono Nerd Font";
              font_weight = 500;
            };

            workspaces = {
              style = "regular";
              show_labels = true;
              label_source = "id";
              hide_when_empty = false;
              active_pill_size = 2.0;
              inactive_pill_size = 1.0;
              focused_color = "primary";
              occupied_color = "secondary";
              empty_color = "surface_variant";
              urgent_color = "error";
            };

            privacy = {
              type = "privacy";
              hide_inactive = true;
              icon_spacing = 6;
            };

            notifications = {
              hide_when_no_unread = false;
            };

            network = {
              show_label = false;
            };

            bluetooth = {
              show_label = false;
            };

            battery = {
              show_label = false;
              hide_when_full = false;
            };

            volume = {
              device = "output";
              show_label = false;
            };

            mic = {
              type = "volume";
              device = "input";
              show_label = false;
            };

            clock = {
              capsule = false;
              format = "{:%H:%M %a, %b %d}";
              tooltip_format = "%A, %d %B %Y";
              font_family = "JetBrainsMono Nerd Font";
              font_weight = 500;
            };

            control-center = {
              capsule = true;
              capsule_fill = "primary";
              color = "on_primary";
            };
          };
        };
      };
    };
}
