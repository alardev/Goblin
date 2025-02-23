{ ... }: {
  conf = {
    ssh.enable = true;
    nginx.enable = true;
    netdata.enable = true;
    mail.enable = false; # broken
    website.enable = true;
    fedi.enable = true;
    matrix.enable = true;
    git.enable = true;

    stateVersion = "25.05";
    hmStateVersion = "25.05";
  };
}
