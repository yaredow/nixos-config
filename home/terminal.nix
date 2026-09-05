{ ... }:
{
  # Fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting  # Silence the default greeting
    '';
    shellAliases = {
      ll = "ls -la";
      v = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
    };
  };

  # Kitty terminal
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      background_opacity = "0.90";
      window_padding_width = 10;
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
  };
}
