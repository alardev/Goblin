{config, ...}: let
  inherit (config) conf;
in {
  imports = [
    ./apps
    ./containers
    ./email
    ./fedi
    ./firewall
    ./fonts
    ./games
#    ./git
    ./home
    ./layout
    ./matrix
    ./networking
    ./nginx
    ./niri
    ./nix
    ./secureboot
    ./ssh
    ./utils
    ./vm
    ./website
#    ./yubikey
  ];

  documentation.nixos.enable = false;

  time.timeZone = "Europe/Tallinn";
  i18n = {
    defaultLocale = "en_IE.UTF-8";
  };

  users.users.${conf.username} = {
    isNormalUser = true;
    description = conf.username;
    extraGroups = ["wheel"];
  };

  system.stateVersion = conf.stateVersion;
}
