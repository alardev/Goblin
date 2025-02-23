{ lib, pkgs, config, ... }: let
  inherit (lib) mkIf;
  inherit (config) conf;
  inherit ((pkgs.formats.elixirConf { }).lib) mkMap;
in mkIf conf.fedi.enable {
  services.akkoma = {
    enable = true;
    config = {
      ":pleroma" = {
        ":instance" = {
          name = "miras fedi";
          description = "miras akkoma instance";
          email = "fedi@chpu.eu";
          registration_open = false;
        };

        ":mrf_simple" = {
          reject = mkMap {
          };
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
      serverName = "fedi.twoneis.site";
      useACMEHost = "twoneis.site";
      forceSSL = true;
    };
  };
}
