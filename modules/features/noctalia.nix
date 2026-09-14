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
              thickness = 34;
              margin_edge = 8;
              margin_ends = 16;
              radius = 12;
              background_opacity = 0.0;
              border_width = 0.0;
              capsule = true;
              capsule_fill = "#1e2030";
              capsule_border = "#3b4261";
              capsule_opacity = 0.95;
              capsule_padding = 8.0;
              capsule_radius = 10.0;
              capsule_thickness = 0.85;
              widget_spacing = 8;
              padding = 0;
              font_family = "CaskaydiaCove Nerd Font";
              font_weight = 600;

              start = [
                "launcher"
                "workspaces"
                "active_window"
              ];
              center = [ "clock" ];
              end = [
                "media"
                "tray"
                "notifications"
                "network"
                "volume"
                "control-center"
                "session"
              ];
              capsule_group = [
                [ "network" "volume" ]
                [ "control-center" "session" ]
              ];
            };
          };

          widget = {
            launcher = {
              custom_image = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              custom_image_colorize = true;
              icon_color = "primary";
              capsule_fill = "#1e2030";
            };

            workspaces = {
              style = "focus_hint";
              show_icons = true;
              show_labels = true;
              label_source = "id";
              hide_when_empty = false;
              focused_color = "primary";
            };

            active_window = {
              icon_size = 14.0;
              max_length = 260.0;
              show_empty_label = false;
            };

            clock = {
              format = " {:%H:%M}  󰃭 {:%a %d %b}";
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
            };

            control-center = {
              glyph = "adjustments-horizontal";
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
