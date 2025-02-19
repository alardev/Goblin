{ config, lib, ... }: let
  inherit (config) conf;
  inherit (lib) mkIf;
in mkIf conf.matrix.enable {
  services.nginx.virtualHosts = {
    "twoneis.site" = {
      serverName = "twoneis.site";
      useACMEHost = "twoneis.site";
      forceSSL = true;
      locations = {
        "/.well-known/matrix/server" = {
          return = "200 '{\"m.server\": \"matrix.twoneis.site:443\"}'";
        };
      };
    };
    "matrix.twoneis.site" = {
      listen = [
        {
          addr = "95.111.239.134";
          port = 443;
          ssl = true;
        } {
          addr = "95.111.239.134";
          port = 8448;
          ssl = true;
        }
      ];
      serverName = "matrix.twoneis.site";
      forceSSL = true;
      useACMEHost = "twoneis.site";
      locations = {
        "/" = {
          proxyPass = "http://localhost:6167";
        };
      };
    };
  };

  services.conduwuit = {
    enable = true;
    settings.global = {
      server_name = "matrix.twoneis.site";
      allow_registration = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 443 8448 ];
}
