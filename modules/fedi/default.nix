{ lib, pkgs, config, ... }: let
  inherit (lib) mkIf;
  inherit (config) conf;
in mkIf conf.fedi.enable {
  services.akkoma = {
    enable = true;
    config = {
      ":pleroma" = {
        ":instance" = {
          name = "miras fedi";
          description = "miras akkoma instance";
          email = "mira.cp.0909@gmail.com";
          registration_open = false;
        };

        "Pleroma.Web.Endpoint" = {
          url.host = "fedi.twoneis.site";
        };

        "Pleroma.Upload" = {
          base_url = "https://fedi.twoneis.site/media/";
        };
      };
    };
    nginx = {
      useACMEHost = "twoneis.site";
      forceSSL = true;
    };
  };
}
