{ ... }: {
  conf = {
    ssh.enable = true;
    nginx.enable = true;
    mail.enable = false; # broken
    website.enable = false; # broken
    fedi.enable = false; # broken
    matrix.enable = true; # broken
    git.enable = true;

    stateVersion = "25.05";
    hmStateVersion = "25.05";
  };
}
