{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) conf;
  cfg = config.conf.ssh;
in
  mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
      };
    };
  }
