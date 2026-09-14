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
              capsule = false;
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
              glyph = "volume-2";
              mute_glyph = "volume-off";
            };

            battery = {
              show_label = true;
              hide_when_full = false;
            };

            control-center = {
              glyph = "settings-2";
            };

            session = {
              glyph = "power";
              color = "error";
            };
          };
        };
      };
    };
}
