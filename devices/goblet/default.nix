{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./options.nix
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };

  networking.hostName = "goblet";

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
      #luks.devices.root.device = "/dev/disk/by-label/CRYPT";
      kernelModules = ["amdgpu kvm-amd"];
    };
    kernelPackages = pkgs.linuxPackages_cachyos;
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/B5A2-B366";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
    "/" = {
      device = "/dev/disk/by-uuid/32b9fb56-5f98-49b4-a6f2-949512a8feb0";
      fsType = "xfs";
    };
  };
  swapDevices = [];

  chaotic.mesa-git.enable = true;
  chaotic.hdr.enable = true;

  services = {
    fwupd.enable = true;
    power-profiles-daemon.enable = true;
    logrotate.checkConfig = false;
    scx = {
      enable = true;
      package = pkgs.scx_git.rustscheds;
      scheduler = "scx_lavd";
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
