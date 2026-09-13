{ self, ... }: { flake.homeModules.default = { ... }: { imports = [ self.homeModules.helix self.homeModules.alacritty ]; }; }
