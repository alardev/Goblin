{ config, lib, ... }: let
  inherit (config) conf;
  inherit (lib) mkIf;
in mkIf conf.nginx.enable {
  services.nginx = {
    enable = true;
    virtualHosts = {
      ".twoneis.site" = {
        serverName = ".twoneis.site";
        forceSSL = false;
        locations = {
          "/" = {
            return = "404";
          };
        };
      };
    };
  };
}
