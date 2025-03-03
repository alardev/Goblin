{
  config,
  lib,
  ...
}: let
  inherit (config) conf;
  inherit (lib) mkIf;
in
  mkIf conf.nginx.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "mira@chpu.eu";
      certs = {
        "twoneis.site" = {
          group = "nginx";
          domain = "twoneis.site";
          extraDomainNames = ["*.twoneis.site"];
          dnsProvider = "porkbun";
          email = "mira@chpu.eu";
          environmentFile = "/root/porkbun-creds";
        };

        "chpu.eu" = {
          group = "nginx";
          domain = "chpu.eu";
          extraDomainNames = ["*.chpu.eu"];
          dnsProvider = "porkbun";
          email = "mira@chpu.eu";
          environmentFile = "/root/porkbun-creds";
        };
      };
    };

    users.users.nginx.extraGroups = ["acme"];

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "chpu.eu" = {
          serverName = "chpu.eu";
          useACMEHost = "chpu.eu";
          forceSSL = true;
        };
        "twoneis.site" = {
          serverName = "twoneis.site";
          useACMEHost = "twoneis.site";
          forceSSL = true;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  }
