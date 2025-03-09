{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.conf.containers;
in
  mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
  }
