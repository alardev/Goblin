{pkgs, ...}: {
  imports = [
    ./options.nix
    ./disko.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking = {
    hostName = "ellaca";
    domain = "twoneis.site";
  };

  boot = {
    initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod"];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        devices = ["/dev/sda"];
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = ["/"];
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
  };
}
