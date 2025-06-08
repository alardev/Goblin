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
      layout = "ee,ua,ru";
      variant = "phonetic,us,phonetic";
      options = "grp:lalt_lshift_toggle";
    };

    console.useXkbConfig = true;
  }
