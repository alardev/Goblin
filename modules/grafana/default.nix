{ lib, pkgs, config, ... }: let
  inherit (lib) mkIf;
  inherit (config) conf;
  cfg = config.services.grafana.settings.server;
in mkIf conf.grafana.enable {
  services.nginx = {
    virtualHosts = {
      "grafana.twoneis.site" = {
        useACMEHost = "twoneis.site";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://${toString cfg.http_addr}:${toString cfg.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "grafana.twoneis.site";
      };
    };
  };
}
