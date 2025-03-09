{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.conf.website;
in
  mkIf cfg.enable {
    services.nginx.virtualHosts = {
      ${cfg.domain.full} = {
        default = true;
        serverName = cfg.domain.full;
        useACMEHost = cfg.domain.base;
        forceSSL = true;
        root = "/var/lib/website/";
      };
    };
  }
