{...}: {
  conf = {
    host = "laptop";
    secureboot.enable = true;
    yubikey.login = true;

    stateVersion = "24.11";
    hmStateVersion = "24.11";
  };
}
