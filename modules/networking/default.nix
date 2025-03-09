{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config) conf;
  inherit (lib) mkIf;
  cfg = config.conf.networkmanager;
in
  mkIf cfg.enable {
    users.users.${conf.username}.extraGroups = ["networkmanager"];

    home-manager.users.${conf.username}.home.packages = [pkgs.networkmanagerapplet];
    networking = {
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      extraHosts = ''
        10.10.11.245 surveillance.htb
      '';
    };
  }
