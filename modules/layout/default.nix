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
      layout = "custom,us";
      options = "compose:ralt";

      extraLayouts."custom" = {
        description = "custom dvorak-like layout.";
        languages = ["en"];
        symbolsFile = ./custom.xkb;
      };
    };

    console.useXkbConfig = true;
  }
