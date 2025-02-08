{ lib, pkgs, config, ... }: let
  inherit (lib) mkIf;
  inherit (config) conf;
in mkIf conf.fedi.enable {
  environment.systemPackages = [
    (pkgs.callPackage ./iceshrimp.nix { })
  ];
}
