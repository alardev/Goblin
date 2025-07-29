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
    kernelPackages = pkgs.linuxPackages_testing;
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
  #  chaotic.hdr.enable = true;

  services = {
    fwupd.enable = true;
    power-profiles-daemon.enable = true;
    logrotate.checkConfig = false;
    udev.packages = with pkgs; [imsprog];
    scx = {
      enable = true;
      package = pkgs.scx_git.rustscheds;
      scheduler = "scx_lavd";
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    wirelessRegulatoryDatabase = true;
    firmware = with pkgs; [wireless-regdb];
    cpu.amd.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="EE"
  '';

  boot.kernelPatches = [
    {
      name = "WCN7850 patches";
      patch = null;
      # patch = pkgs.fetchurl {
      #   url = "https://lore.kernel.org/linux-wireless/20250722095934.67-4-kang.yang@oss.qualcomm.com/t.mbox.gz";
      #   hash = "sha256-oDxL9D+i8ZDroz2ameLV/z1KP/2+MT8D7WGZgF3MCOA=";
      # };
      extraConfig = ''
        CFG80211_CERTIFICATION_ONUS y
        ATH_REG_DYNAMIC_USER_REG_HINTS y
      '';
    }
  ];
}
