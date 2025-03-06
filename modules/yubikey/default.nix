{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) conf;
in
  mkIf conf.yubikey.enable {
    services.udev.packages = [pkgs.yubikey-personalization];
    services.pcscd.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    home-manager.users.${conf.username}.home.packages = with pkgs; [
      yubioath-flutter
    ];
  }
