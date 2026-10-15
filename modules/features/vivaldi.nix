{ ... }:
{
  flake.nixosModules.vivaldi = { ... }: {
    environment.etc."chromium/policies/managed/default.json".text = builtins.toJSON {
      CommandLineFlagSecurityWarningsEnabled = false;
    };
  };

  flake.homeModules.vivaldi = { pkgs, ... }: {
    programs.vivaldi = {
      enable = true;
      package = pkgs.vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
      };
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"

        "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,TouchpadOverscrollHistoryNavigation,WebRTCPipeWireCapturer"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
      ];
    };
  };
}
