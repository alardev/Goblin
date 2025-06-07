{config, ...}: let
  inherit (config) conf;
in {
  imports = [
    ./apps
    ./containers
    ./firewall
    ./fonts
    ./games
    #    ./git
    ./home
    ./layout
    ./networking
    ./niri
    ./nix
    ./secureboot
    ./ssh
    ./utils
    ./vm
    #    ./yubikey
  ];

  documentation.nixos.enable = false;

  time.timeZone = "Europe/Tallinn";
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  users.users.${conf.username} = {
    isNormalUser = true;
    description = conf.username;
    extraGroups = ["wheel"];
  };

  system.stateVersion = conf.stateVersion;
}
