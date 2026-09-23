{ inputs, ... }: {
  flake.nixosModules.niri = { pkgs, ... }:
    let
      wallpaperPath = "${../../../assets/omanix-blurred.png}";
    in
    {
      programs.niri.enable = true;
      services.greetd.enable = true;
      services.displayManager.noctalia-greeter = {
        enable = true;
        package = pkgs.noctalia-greeter.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace src/greeter/greeter_surface.cpp \
              --replace-fail 'const float panelWidth = std::clamp(sw * 0.32f, Style::scaled(440.0f), Style::scaled(540.0f));' \
                             'const float panelWidth = Style::scaled(380.0f);'
          '';
        });
        settings = {
          session.default = "Niri";
          user.default = "yada";
          appearance = {
            scheme = "Synced";
            password_style = "default";
            hide_logo = true;
            power_buttons_position = "bottom-right";
            scheme_selector_position = "hidden";
            theme_mode = "dark";
            font_family = "JetBrainsMono Nerd Font";
            corner_radius_scale = 1.0;
            palette = {
              primary = "#7aa2f7";
              on_primary = "#1a1b26";
              secondary = "#bb9af7";
              on_secondary = "#1a1b26";
              tertiary = "#7dcfff";
              on_tertiary = "#1a1b26";
              error = "#f7768e";
              on_error = "#1a1b26";
              surface = "#1a1b26";
              on_surface = "#c0caf5";
              surface_variant = "#24283b";
              on_surface_variant = "#a9b1d6";
              outline = "#414868";
              shadow = "#15161e";
              hover = "#7aa2f7";
              on_hover = "#1a1b26";
            };
            wallpaper = {
              path = wallpaperPath;
              fill_mode = "crop";
            };
          };
          keyboard = {
            layout = "us";
            numlock = true;
          };
          cursor = {
            theme = "Adwaita";
            size = 24;
          };
        };
      };
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };

  flake.homeModules.niri = { pkgs, ... }: {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    xdg.configFile."niri/config.kdl".source = ./config.kdl;
  };
}
