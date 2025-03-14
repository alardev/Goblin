{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.conf.extraLayout;
in
  mkIf cfg.enable {
    services.xserver.xkb = {
      layout = "ie,ua";
    };

    console.useXkbConfig = true;
  }
