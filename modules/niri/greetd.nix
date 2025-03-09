{
  config,
  pkgs,
  ...
}: let
  inherit (config) conf;
  niri = config.programs.niri.package;
in {
  default_session = {
    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd ${niri}/bin/niri-session --remember";
    user = conf.username;
  };
}
