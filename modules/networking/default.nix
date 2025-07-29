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
      wireless = {
        enable = true;
        iwd.enable = false;
        iwd.settings.general.ControlPortOverNL80211 = false;
        userControlled.enable = true;
        athUserRegulatoryDomain = true;
        dbusControlled = true;
      };
    };
  }
