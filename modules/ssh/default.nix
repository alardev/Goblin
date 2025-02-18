{ lib, config, ... }: let
  inherit (lib) mkIf;
  inherit (config) conf;
in mkIf conf.ssh.enable {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYy89cBNXjet2kBbOw7CKMJguyIq72EQV8ixo836nOH"
  ];

  users.users.${conf.username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYy89cBNXjet2kBbOw7CKMJguyIq72EQV8ixo836nOH"
  ];
}
