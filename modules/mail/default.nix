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
    streamConfig = ''
      server {
          listen 25 proxy_protocol;
          proxy_pass 127.0.0.1:10025;
          proxy_protocol on;
      }

      server {
          listen 993 proxy_protocol;
          proxy_pass 127.0.0.1:10993;
          proxy_protocol on;
      }

      server {
          listen 465 proxy_protocol;
          proxy_pass 127.0.0.1:10465;
          proxy_protocol on;
      }
    '';
  };

  services.stalwart-mail = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        hostname = "chpu.eu";
        tls = {
          enable = true;
          implicit = true;
        };
        proxy = {
          
        };
        listener = {
          smtp = {
            protocol = "smtp";
            bind = "[::]:10025";
          };
          submissions = {
            protocol = "smtp";
            bind = "[::]:10465";
          };
          imaps = {
            protocol = "imap";
            bind = "[::]:10993";
          };
          jmap = {
            protocol = "jmap";
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
        cert = "%{file:/var/lib/acme/chpu.eu/cert.pem}%";
        private-key = "%{file:/var/lib/acme/chpu.eu/key.pem}";
      };
      session.auth = {
        mechanism = "[plain]";
        directory = "'in-memory'";
      };
      storage.directory = "in-memory";
      session.rcpt.directory = "'in-memory'";
      queue.outbound.next-hop = "'local'";
      directory."imap".lookup.demains = [ "chpu.eu" ];
      directory."in-memory" = {
        type = "memory";
        principals = [
          {
            class = "individual";
            name = "mira@chpu.eu";
            secret = "%{file:/root/email-mira-passwd}%";
            email = [ "mira@chpu.eu" ];
          }
        ];
      };
      authentication.fallback-admin = {
        user = "admin";
        secret = "%{file:/root/stalwart-admin-passwd}%";
      };
    };
  };
}
