{ ... }: {
  conf = {
    ssh.enable = true;
    nginx.enable = true;

    stateVersion = "25.05";
    hmStateVersion = "25.05";
  };
}
