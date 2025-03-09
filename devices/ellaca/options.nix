{...}: let
  email-domain = "chpu.eu";
  web-domain = "twoneis.site";
in {
  conf = {
    host = "server";
    nginx = {
      domains = [
        email-domain
        web-domain
      ];
      email = "mira@${email-domain}";
    };

    email = {
      domain = email-domain;
      ports = {
        smtp = 25;
        imaps = 993;
        smtps = 465;
        local = 9000;
      };
    };

    website = {
      domain = {
        full = web-domain;
        base = web-domain;
      };
    };

    fedi = {
      domain = {
        full = "fedi.${web-domain}";
        base = web-domain;
      };
      email = "akkoma@${email-domain}";
    };

    matrix = {
      domain = {
        full = "matrix.${web-domain}";
        base = web-domain;
      };

      email = "matrix@${email-domain}";
    };

    git = {
      domain = {
        full = "git.${web-domain}";
        base = web-domain;
      };
      ports = {
        local = 3000;
      };
    };

    stateVersion = "25.05";
    hmStateVersion = "25.05";
  };
}
