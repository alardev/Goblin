{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkForce;
  cfg = config.conf.secureboot;
in
  mkIf cfg.enable {
    environment.systemPackages = [pkgs.sbctl];

    boot.loader.systemd-boot.enable = mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  }
