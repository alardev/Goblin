{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) conf;
in
  mkIf (conf.host != "server") {
    home-manager.users.${conf.username} = {
      home.packages = with pkgs; [
        loupe
        spotify
        amberol
      ];

      programs.mpv = {
        enable = true;
      };
    };
  }
