{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge mkIf;
  inherit (config) conf;
in
  mkMerge [
    (mkIf
      conf.yubikey.enable
      {
        services.udev.packages = [pkgs.yubikey-personalization];
        services.pcscd.enable = true;

        programs.gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };

        home-manager.users.${conf.username}.home.packages = with pkgs; [
          yubioath-flutter
        ];
      })
    (mkIf
      conf.yubikey.login
      {
        security.pam.u2f = {
          enable = true;
          cue = true;
          control = "required";
        };
      })
  ]
