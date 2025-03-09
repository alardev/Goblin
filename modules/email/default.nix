{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.lists) forEach;
  cfg = config.conf.email;
in
  mkIf cfg.enable {
    services.nginx = {
      virtualHosts.${cfg.domain} = {
        serverName = cfg.domain;
        serverAliases =
          forEach ["mail" "webadmin" "autoconfig" "autodiscover"]
          (sub: "${sub}.${cfg.domain}");
        forceSSL = true;
        useACMEHost = cfg.domain;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString cfg.ports.local}";
          };
        };
      };
    };

    users.users."stalwart-mail".extraGroups = ["nginx"];

    services.stalwart-mail = {
      enable = true;
      openFirewall = true;
      settings = {
        config.local-keys = [
          "certificate.default.cert"
          "certificate.default.private-key"
          "authentication.fallback-admin.secret"
        ];
        server = {
          hostname = cfg.domain;
          tls = {
            enable = true;
            implicit = true;
          };
          listener = {
            smtp = {
              protocol = "smtp";
              bind = ["[::]:${toString cfg.ports.smtp}"];
            };
            imaps = {
              protocol = "imap";
              bind = ["[::]:${toString cfg.ports.imaps}"];
            };
            submissions = {
              protocol = "smtp";
              bind = ["[::]:${toString cfg.ports.smtps}"];
            };
            management = {
              protocol = "http";
              bind = "127.0.0.1:${toString cfg.ports.local}";
            };
          };
        };
        lookup.default = {
          hostname = cfg.domain;
          domain = cfg.domain;
        };
        certificate.default = {
          default = true;
          cert = "%{file:/var/lib/acme/${cfg.domain}/cert.pem}%";
          private-key = "%{file:/var/lib/acme/${cfg.domain}/key.pem}%";
        };
        storage = {
          data = "db";
          fts = "db";
          block = "db";
          lookup = "db";
          directory = "internal";
        };
        directory."internal" = {
          type = "internal";
          store = "db";
        };
        tracer."stdout" = {
          type = "stdout";
          level = "info";
          ansi = false;
          enable = true;
        };
        session.rcpt = {
          directory = "'internal'";
        };
        authentication.fallback-admin = {
          user = "admin";
          secret = "%{file:/var/lib/stalwart-mail/secret/admin}%";
        };
      };
    };
  }
