{ self, ... }: {
  flake.nixosModules.screen-recorder = { pkgs, ... }: {
    # System setcap wrappers for hardware-accelerated capture
    programs.gpu-screen-recorder.enable = true;
  };

  flake.homeModules.screen-recorder = { pkgs, ... }:
    let
      screenrecord-toggle = pkgs.writeShellApplication {
        name = "screenrecord-toggle";
        runtimeInputs = with pkgs; [
          slurp
          gpu-screen-recorder
          procps
          coreutils
        ];
        text = builtins.readFile ./record.sh;
      };
    in
    {
      home.packages = with pkgs; [
        slurp
        gpu-screen-recorder
        screenrecord-toggle
      ];
    };
}
