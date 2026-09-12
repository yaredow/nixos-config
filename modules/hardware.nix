{
  flake.modules.nixos.hardware-vm = { lib, modulesPath, ... }: {

    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    boot.initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "virtio_blk"
      "virtio_scsi"
      "virtio_net"
      "sr_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    swapDevices = [ ];
    zramSwap.enable = true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
