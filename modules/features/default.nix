{ self, ... }: {
  flake.homeModules.default = { ... }: {
    imports = [
      self.homeModules.neovim
      self.homeModules.alacritty
      self.homeModules.fish
      self.homeModules.starship
      self.homeModules.niri
      self.homeModules.noctalia
      self.homeModules.antigravity
      self.homeModules.mpv
      self.homeModules.herdr
      self.homeModules.theme
    ];
  };
}
