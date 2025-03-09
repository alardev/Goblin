{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) conf;
  cfg = config.conf.ssh;
in
  mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };

    users.users.${conf.username}.openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINKg0qThAxqNZjEVhXQ+ds7/CpMAeF1AKsVfQUW8CbtqAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIE+6ILh1iUkD8FSWlmd2MCH+il8wOXbkkl7U01z/pZQfAAAABHNzaDo="
    ];
  }
