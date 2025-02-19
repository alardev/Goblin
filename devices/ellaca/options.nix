{ ... }: {
  conf = {
    ssh.enable = true;
    nginx.enable = true;
    mail.enable = true; # broken
    website.enable = false; # broken
    fedi.enable = false; # broken
    matrix.enable = true;
    git.enable = true;

    stateVersion = "25.05";
    hmStateVersion = "25.05";
  };
}
