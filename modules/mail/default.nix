{ config, lib, ... }: let
  inherit (config) conf;
  inherit (lib) mkIf;
in mkIf conf.mail.enable {
  services.nginx = {
    virtualHosts = {
      "webadmin.chpu.eu" = {
        useACMEHost = "chpu.eu";
        forceSSL = true;
        serverAliases = [
          "mta-sts.chpu.eu"
          "autoconfig.chpu.eu"
          "autodiscover.chpu.eu"
          "mail.chpu.eu"
        ];
        locations."/".proxyPass = "http://localhost:8080";
      };
    };
  };

  users.users."stalwart-mail".extraGroups = [ "nginx" ];

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
        hostname = "chpu.eu";
        tls = {
          enable = true;
          implicit = true;
        };
        listener = {
          smtp = {
            protocl = "smtp";
            bind = "[::]:25";
          };
          submissions = {
            protocol = "smtp";
            bind = "[::]:465";
          };
          imaps = {
            protocol = "imap";
            bind = "[::]:993";
          };
          jmap = {
            protocol = "http";
            bind = "[::]:8080";
            url = "https://mail.chpu.eu";
          };
          management = {
            protocol = "http";
            bind = [ "127.0.0.1:8080" ];
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
      session.auth = {
        mechanism = "[plain]";
        directory = "'in-memory'";
      };
      storage.directory = "in-memory";
      session.rcpt.directory = "'in-memory'";
      directory."imap".lookup.demains = [ "chpu.eu" ];
      directory."in-memory" = {
        type = "memory";
        principals = [
          {
            class = "individual";
            name = "mira";
            description = "Mira Chacku Purakal";
            secret = "%{file:/var/lib/stalwart-mail/secret/mira}%";
            email = [ "mira@chpu.eu" ];
          }
        ];
      };
      authentication.fallback-admin = {
        user = "admin";
        secret = "%{file:/var/lib/stalwart-mail/secret/admin}%";
      };
    };
  };
}
