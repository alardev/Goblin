{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) conf;
in
  mkIf conf.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };

    users.users.${conf.username}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYy89cBNXjet2kBbOw7CKMJguyIq72EQV8ixo836nOH"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINKg0qThAxqNZjEVhXQ+ds7/CpMAeF1AKsVfQUW8CbtqAAAABHNzaDo="
    ];
  }
