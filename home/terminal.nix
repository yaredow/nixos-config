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
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
    };
  };

  # Kitty terminal
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "CaskaydiaCove Nerd Font";
      font_size = 10;
      background_opacity = "0.90";
      window_padding_width = 10;
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
  };
}
