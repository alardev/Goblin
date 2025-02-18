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
        mechanism = "[plain, login]";
        directory = "'default'";
        must-match-sender = false;
      };
      store = {
        rocksdb = {
          type = "rocksdb";
          path = "/opt/stalwart/data";
        };
      };
      storage = {
        data = "rocksdb";
        directory = "default";
        lookup = "rocksdb";
      };
      session.rcpt.directory = "'default'";
      directory."imap".lookup.demains = [ "chpu.eu" ];
      directory."default" = {
        type = "internal";
        store = "rocksdb";
        principals = [
          {
            class = "individual";
            name = "mira@chpu.eu";
            description = "Mira Chacku Purakal";
            secret = "%{file:/var/lib/stalwart-mail/secret/mira}%";
            emails = [ "mira@chpu.eu" ];
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
