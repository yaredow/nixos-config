{ inputs, ... }:
{
  flake.nixosModules.helium = { ... }: {
    imports = [
      inputs.helium-browser.nixosModules.default
    ];
  };

  flake.homeModules.helium = { pkgs, ... }: {
    imports = [
      inputs.helium-browser.homeModules.default
    ];

    programs.helium = {
      enable = true;
      package = inputs.helium-browser.packages.${pkgs.system}.default;
      flags = [
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
