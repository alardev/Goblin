{...}: {
  conf = {
    host = "tablet";
    secureboot.enable = true;
    yubikey.login = true;
    games.enable = true;

    stateVersion = "24.11";
    hmStateVersion = "24.11";
  };
}
