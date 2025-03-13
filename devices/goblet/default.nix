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
      kernelModules = ["amdgpu"];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = mkDefault true;
        editor = false;
      };
      grub.device = "nodev";
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
    };
 };
  swapDevices = [];

  services = {
    fwupd.enable = true;
    power-profiles-daemon.enable = true;
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
