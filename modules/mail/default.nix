{
  config,
  lib,
  ...
}: let
  inherit (config) conf;
  inherit (lib) mkIf;
in
  mkIf conf.mail.enable {
    services.nginx = {
      virtualHosts."chpu.eu" = {
        serverName = "chpu.eu";
        serverAliases = [
          "webadmin.chpu.eu"
          "autoconfig.chpu.eu"
          "autodiscover.chpu.eu"
        ];
        forceSSL = true;
        useACMEHost = "chpu.eu";
        locations = {
          "/" = {
            proxyPass = "http://localhost:9090";
          };
        };
      };
    };

    users.users."stalwart-mail".extraGroups = ["nginx"];

    services.stalwart-mail = {
      enable = true;
      settings = {
        config.local-keys = [
          "certificate.default.cert"
          "certificate.default.private-key"
          "authentication.fallback-admin.secret"
        ];
        server = {
          hostname = "chpu.eu";
          tls = {
            enable = true;
            implicit = true;
          };
          listener = {
            submissions = {
              protocol = "smtp";
              bind = "[::]:465";
            };
            smtp = {
              protocol = "smtp";
              bind = "[::]:25";
            };
            imaps = {
              protocol = "imap";
              bind = "[::]:993";
            };
            management = {
              protocol = "http";
              bind = "127.0.0.1:9090";
            };
          };
        };
        lookup.default = {
          hostname = "chpu.eu";
          domain = "chpu.eu";
        };
        certificate.default = {
          default = true;
          cert = "%{file:/var/lib/acme/chpu.eu/cert.pem}%";
          private-key = "%{file:/var/lib/acme/chpu.eu/key.pem}%";
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
