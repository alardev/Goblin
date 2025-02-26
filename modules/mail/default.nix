{ config, lib, ... }: let
  inherit (config) conf;
  inherit (lib) mkIf;
in mkIf conf.mail.enable {
  services.nginx.streamConfig = ''
    # Proxy SMTP
    server {
      server_name chpu.eu mail.chpu.eu;
      listen 25 proxy_protocol;
      proxy_pass 127.0.0.1:10025;
      proxy_protocol on;
    }

    # Proxy IMAPS
    server {
      server_name chpu.eu mail.chpu.eu;
      listen 993 proxy_protocol;
      proxy_pass 127.0.0.1:10993;
      proxy_protocol on;
    }

    # Proxy SMTPS
    server {
      server_name chpu.eu mail.chpu.eu;
      listen 465 proxy_protocol;
      proxy_pass 127.0.0.1:10465;
      proxy_protocol on;
    }

    # Proxy HTTPS
    server {
      server_name chpu.eu mail.chpu.eu;
      listen 443 proxy_protocol;
      proxy_pass 127.0.0.1:10443;
      proxy_protocol on;
    }
  '';

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
        proxy.trusted-networks = [
          "127.0.0.0/8"
          "::1"
          "10.0.0.0/8"
        ];
        listener = {
          submissions = {
            protocol = "smtp";
            bind = "127.0.0.1:10465";
          };
          smtp = {
            protocol = "smtp";
            bind = "127.0.0.1:10025";
          };
          imaps = {
            protocol = "imap";
            bind = "127.0.0.1:10993";
          };
          management = {
            protocol = "http";
            bind = [ "127.0.0.1:10443" ];
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
