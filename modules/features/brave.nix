{ ... }:
{
  flake.nixosModules.brave = { ... }: {
    # System-wide enterprise policies to debloat Brave
    # Disables crypto, rewards, wallet, Leo AI, VPN, and IPFS
    environment.etc."brave/policies/managed/default.json".text = builtins.toJSON {
      BraveRewardsDisabled = true;
      BraveWalletDisabled = true;
      BraveVPNDisabled = true;
      BraveAIChatEnabled = false;
      BraveNewsDisabled = true;
      IPFSEnabled = false;
      TorDisabled = true;
    };
  };

  flake.homeModules.brave = { ... }: {
    programs.brave = {
      enable = true;
      commandLineArgs = [
        # Native Wayland
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"

        # Hardware video acceleration & gesture navigation (Intel Iris Xe)
        "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,TouchpadOverscrollHistoryNavigation"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
      ];
    };
  };
}
