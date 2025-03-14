{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit ((pkgs.formats.elixirConf {}).lib) mkMap;
  cfg = config.conf.fedi;

  akkoma-fe = pkgs.callPackage ./akkoma-fe.nix {};
  neocat = pkgs.callPackage ./neocat.nix {};
  neofox = pkgs.callPackage ./neofox.nix {};
  blobfox = pkgs.callPackage ./blobfox.nix {};
  blobhaj = pkgs.callPackage ./blobhaj.nix {};
  blobhajFlags = pkgs.callPackage ./blobhajFlags.nix {};
  favicon = pkgs.callPackage ./favicon.nix {};
  iceshrimp = pkgs.callPackage ./iceshrimp/iceshrimp.nix {};
in
  mkIf cfg.enable {
    environment.systemPackages = [iceshrimp];
    services.akkoma = {
      enable = true;
      frontends.primary = {
        name = "akkoma_fe";
        ref = "stable";
        package = akkoma-fe;
      };
      config = {
        ":pleroma" = {
          ":instance" = {
            name = "miras fedi";
            description = "miras akkoma instance";
            email = cfg.email;
            registration_open = false;
          };

          ":frontend_configurations" = {
            "akkoma_fe" = {
              theme = "rosepine";
              logo = "/static/logo.png";
            };
          };

          # Initial block list copied from void.rehab
          ":mrf_simple" = {
            reject = mkMap (import ./blocklist.nix);
          };

          "Pleroma.Web.Endpoint" = {
            url.host = cfg.domain.full;
          };

          "Pleroma.Upload" = {
            base_url = "https://${cfg.domain.full}/media/";
          };
        };
      };
      extraStatic = {
        "emoji/neocat" = neocat;
        "emoji/neofox" = neofox;
        "emoji/blobfox" = blobfox;
        "emoji/blobhaj" = blobhaj;
        "emoji/blobhajFlags" = blobhajFlags;

        "static/favicon.png" = favicon;
        "static/logo.png" = favicon;
        "favicon.png" = favicon;
      };

      nginx = {
        serverName = cfg.domain.full;
        useACMEHost = cfg.domain.base;
        forceSSL = true;
      };
    };
  }
