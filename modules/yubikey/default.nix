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
          control = "required";
          settings = {
            cue = true;
          };
        };

        # Lock when removing yubikey
        services.udev.extraRules = ''
          ACTION=="remove",\
           ENV{ID_BUS}=="usb",\
           ENV{ID_MODEL_ID}=="0407",\
           ENV{ID_VENDOR_ID}=="1050",\
           ENV{ID_VENDOR}=="Yubico",\
           RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        '';
      })
  ]
