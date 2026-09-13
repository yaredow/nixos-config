{ self, ... }: {
  flake.homeModules.default = { ... }: {
    imports = [
      self.homeModules.helix
      self.homeModules.alacritty
      self.homeModules.fish
      self.homeModules.starship
    ];
  };
}
