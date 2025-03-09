{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.conf.git;
in
  mkIf cfg.enable {
    services = {
      nginx = {
        virtualHosts.${cfg.domain.full} = {
          serverName = cfg.domain.full;
          useACMEHost = cfg.domain.base;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString cfg.ports.local}";
            };
          };
        };
      };

      forgejo = {
        enable = true;
        database = {
          type = "postgres";
        };
        user = "forgejo";
        lfs.enable = true;
        settings = {
          server = {
            DOMAIN = cfg.domain.full;
            ROOT_URL = "https://${cfg.domain.full}";
            HTTP_PORT = cfg.ports.local;
          };
          service.DISABLE_REGISTRATION = true;
          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "github";
          };
        };
      };
    };
  }
