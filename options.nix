{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) nullOr attrsOf listOf enum str bool port;
  inherit (config) conf;
  inherit (config.conf) host;
in {
  options = {
    conf = {
      host = mkOption {
        type = nullOr (enum ["server" "laptop" "desktop" "phone"]);
        default = null;
      };

      niri = {
        enable = mkOption {
          type = bool;
          default = host == "laptop" || host == "desktop";
        };
      };

      vm = {
        enable = mkOption {
          type = bool;
          default = false;
        };
      };

      containers = {
        enable = mkOption {
          type = bool;
          default = false;
        };
      };

      games = {
        enable = mkOption {
          type = bool;
          default = false;
        };
      };

      secureboot = {
        enable = mkOption {
          type = bool;
          default = false;
        };
      };

      extraLayout = {
        enable = mkOption {
          type = bool;
          default = true;
        };
      };

      fonts = {
        enable = mkOption {
          type = bool;
          default = conf.host != "server";
        };
      };

      networkmanager = {
        enable = mkOption {
          type = bool;
          default = conf.host != "server";
        };
      };

      yubikey = {
        enable = mkOption {
          type = bool;
          default = conf.host != "server";
        };
        login = mkOption {
          type = bool;
          default = false;
        };
      };

      ssh = {
        enable = mkOption {
          type = bool;
          default = conf.host == "server";
        };
      };

      nginx = {
        enable = mkOption {
          type = bool;
          default = conf.host == "server";
        };
        domains = mkOption {
          type = listOf str;
          default = [];
        };
        email = mkOption {
          type = nullOr str;
          default = null;
        };
      };

      email = {
        enable = mkOption {
          type = bool;
          default = conf.host == "server";
        };
        domain = mkOption {
          type = nullOr str;
          default = null;
        };
        ports = {
          smtp = mkOption {
            type = nullOr port;
            default = null;
          };
          imaps = mkOption {
            type = nullOr port;
            default = null;
          };
          smtps = mkOption {
            type = nullOr port;
            default = null;
          };
          local = mkOption {
            type = nullOr port;
            default = null;
          };
        };
      };

      website = {
        enable = mkOption {
          type = bool;
          default = conf.host == "server";
        };
        domain = {
          full = mkOption {
            type = nullOr str;
            default = null;
          };
          base = mkOption {
            type = nullOr str;
            default = null;
          };
        };
      };

      fedi = {
        enable = mkOption {
          type = bool;
          default = conf.host == "server";
        };
        domain = {
          full = mkOption {
            type = nullOr str;
            default = null;
          };
          base = mkOption {
            type = nullOr str;
            default = null;
          };
        };
        email = mkOption {
          type = nullOr str;
          default = null;
        };
      };

      matrix = {
        enable = mkOption {
          type = bool;
          default = conf.host == "server";
        };
        domain = {
          full = mkOption {
            type = nullOr str;
            default = null;
          };
          base = mkOption {
            type = nullOr str;
            default = null;
          };
        };
        email = mkOption {
          type = nullOr str;
          default = null;
        };
      };

      git = {
        enable = mkOption {
          type = bool;
          default = conf.host == "server";
        };
        domain = {
          full = mkOption {
            type = nullOr str;
            default = null;
          };
          base = mkOption {
            type = nullOr str;
            default = null;
          };
        };
      };

      username = mkOption {
        type = str;
        default = "alar";
      };

      stateVersion = mkOption {
        type = nullOr str;
        default = null;
      };

      hmStateVersion = mkOption {
        type = nullOr str;
        default = null;
      };

      keys = {
        up = mkOption {
          type = str;
          default = "t";
        };
        down = mkOption {
          type = str;
          default = "n";
        };
        left = mkOption {
          type = str;
          default = "h";
        };
        right = mkOption {
          type = str;
          default = "s";
        };
      };
    };

    theme = mkOption {
      type = attrsOf str;
      default = {
        base = "#191724";
        surface = "#1f1d2e";
        overlay = "#26233a";
        muted = "#6e6a86";
        subtle = "#908caa";
        text = "#e0def4";
        love = "#eb6f92";
        gold = "#f6c177";
        rose = "#ebbcba";
        pine = "#31748f";
        foam = "#9ccfd8";
        iris = "#c4a7e7";
        highlight-low = "#21202e";
        highlight-med = "#403d52";
        highlight-high = "#524f67";
      };
    };
  };
}
