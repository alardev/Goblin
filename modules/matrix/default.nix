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
        "/.well-known/matrix/client" = {
          return = "200 '{\"m.homeserver\": {\"base_url\": \"https://matrix.twoneis.site\"}, \"org.matrix.msc3575.proxy\": {\"url\": \"https://matrix.twoneis.site\"}}'";
        };
        "/.well-known/matrix/support" = {
          return = "200 '{\"contacts\": [{\"matrix_id\": \"@mira:twoneis.site\", \"email_address\": \"matrix@chpu.eu\", \"role\": \"m.role.admin\"}]}'";
        };
      };
    };
    "matrix.twoneis.site" = {
      serverName = "matrix.twoneis.site";
      forceSSL = true;
      useACMEHost = "twoneis.site";
      locations = {
        "/" = {
          proxyPass = "http://localhost:6167";
        };
        "/.well-known/matrix/server" = {
          return = "200 '{\"m.server\": \"matrix.twoneis.site:443\"}'";
        };
        "/.well-known/matrix/client" = {
          return = "200 '{\"m.homeserver\": {\"base_url\": \"https://matrix.twoneis.site\"}, \"org.matrix.msc3575.proxy\": {\"url\": \"https://matrix.twoneis.site\"}}'";
        };
        "/.well-known/matrix/support" = {
          return = "200 '{\"contacts\": [{\"matrix_id\": \"@mira:twoneis.site\", \"email_address\": \"matrix@chpu.eu\", \"role\": \"m.role.admin\"}]}'";
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
