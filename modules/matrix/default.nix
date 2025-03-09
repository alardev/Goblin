{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.attrsets) genAttrs;
  cfg = config.conf.matrix;
in
  mkIf cfg.enable {
    services.nginx.virtualHosts = genAttrs [cfg.domain.base cfg.domain.full] (domain: {
      serverName = domain;
      useACMEHost = cfg.domain.base;
      forceSSL = true;
      locations = {
        "/.well-known/matrix/server" = {
          return = "200 '{\"m.server\": \"${cfg.domain.full}:443\"}'";
        };
        "/.well-known/matrix/client" = {
          return = "200 '{\"m.homeserver\": {\"base_url\": \"https://${cfg.domain.full}\"}, \"org.matrix.msc3575.proxy\": {\"url\": \"https://${cfg.domain.full}\"}}'";
        };
        "/.well-known/matrix/support" = {
          return = "200 '{\"contacts\": [{\"matrix_id\": \"@admin:${cfg.domain.full}\", \"email_address\": \"${cfg.email}\", \"role\": \"m.role.admin\"}]}'";
        };
      };
    });

    services.conduwuit = {
      enable = true;
      settings.global = {
        server_name = cfg.domain.full;
        allow_registration = false;
      };
    };

    networking.firewall.allowedTCPPorts = [8448];
  }
