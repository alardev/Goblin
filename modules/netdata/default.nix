{ lib, pkgs, config, ... }: let
  inherit (lib) mkIf;
  inherit (config) conf;
in mkIf conf.netdata.enable {
  services.nginx = {
    virtualHosts = {
      "netdata.twoneis.site" = {
        useACMEHost = "twoneis.site";
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:19999";
      };
    };
  };

  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { withCloudUI = true; };
    config = {
      global = {
        "memory mode" = "ram";
        "error log" = "syslog";
      };
    };
  };
}
