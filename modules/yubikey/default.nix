{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) conf;
in
  mkIf conf.yuibkey.enable {
  }
