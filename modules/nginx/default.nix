{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.attrsets) genAttrs;
  cfg = config.conf.nginx;
in
  mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.email;
      certs = genAttrs cfg.domains (domain: {
        group = "nginx";
        domain = domain;
        extraDomainNames = ["*.${domain}"];
        dnsProvider = "porkbun";
        email = cfg.email;
        environmentFile = "/root/porkbun-creds";
      });
    };

    users.users.nginx.extraGroups = ["acme"];

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      virtualHosts = genAttrs cfg.domains (domain: {
        serverName = domain;
        useACMEHost = domain;
        forceSSL = true;
      });
    };

    networking.firewall.allowedTCPPorts = [
      443
    ];
  }
