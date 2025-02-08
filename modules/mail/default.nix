{ config, lib, ... }: let
  inherit (config) conf;
  inherit (lib) mkIf;
in mkIf conf.mail.enable {
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
        listener = {
          smtp = {
            protocol = "smtp";
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
            protocol = "jmap";
            bind = "[::]:8080";
            url = "https://chpu.eu";
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
      storage.directory = "'in-memory'";
      session.rcpt.directory = "'in-memory'";
      queue.outbound.next-hop = "'local'";
      directory."imap".lookup.demains = [ "chpu.eu" ];
      directory."in-memory" = {
        type = "memory";
        principals = [
          {
            class = "individual";
            name = "Mira Chacku Purakal";
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
