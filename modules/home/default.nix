{ ... }: {
  imports = [
    ./art
    ./browser
    ./chat
    ./discord
    ./direnv
    ./editor
    ./email
    ./games
    ./gdb
    ./git
    ./media
    ./notes
    ./terminal
    ./utils
  ];

  home = {
    username = "twoneis";
    homeDirectory = "/home/twoneis";

    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
