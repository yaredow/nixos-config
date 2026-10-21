{ self, ... }: {
  flake.nixosModules.i18n = { pkgs, ... }: {
    # Ethiopic typography
    fonts.packages = with pkgs; [
      sil-abyssinica
    ];

    # Input method configuration for Amharic
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-m17n
          fcitx5-gtk
          fcitx5-tokyonight
        ];
        settings = {
          inputMethod = {
            "GroupOrder"."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "keyboard-us";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "m17n_am_sera";
          };
          globalOptions = {
            "Hotkey/TriggerKeys"."0" = "Control+space";
            "Hotkey/AltTriggerKeys"."0" = "Shift_L";
            "Hotkey/EnumerateForwardKeys"."0" = "Control+Shift_L";
          };
          addons.classicui.globalSection = {
            Theme = "Tokyonight-Storm";
            Font = "JetBrainsMono Nerd Font 11";
          };
        };
      };
    };
  };

  flake.homeModules.i18n = { pkgs, ... }: {
    home.packages = with pkgs; [
      kdePackages.fcitx5-configtool
    ];

    xdg.configFile."fcitx5/profile".text = ''
      [GroupOrder]
      0=Default

      [Groups/0]
      Default Layout=us
      DefaultIM=keyboard-us
      Name=Default

      [Groups/0/Items/0]
      Name=keyboard-us

      [Groups/0/Items/1]
      Name=m17n_am_sera
    '';

    xdg.configFile."fcitx5/config".text = ''
      [Hotkey/AltTriggerKeys]
      0=Shift_L

      [Hotkey/EnumerateForwardKeys]
      0=Control+Shift_L

      [Hotkey/TriggerKeys]
      0=Control+space
    '';
  };
}
