{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) conf;
in
  mkIf conf.niri.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = [
      (pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "Fira Code Nerd Font";
        background = "${./sddm.wallpaper.png}";
        loginBackground = true;
      })
    ];

    services.greetd = {
      enable = true;
      settings = import ./greetd.nix {
        config = config;
        pkgs = pkgs;
      };
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    services.upower = {
      enable = true;
    };

    services.logind = {
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
      lidSwitch = "suspend";
      lidSwitchDocked = "suspend";
      lidSwitchExternalPower = "suspend";
    };

    home-manager.users.${conf.username} = {
      home.packages = with pkgs; [
        swayidle
        wl-clipboard
      ];

      services.swayosd = {
        enable = true;
        topMargin = 0.8;
        stylePath =
          pkgs.writeText "swayosd.css"
          (import ./swayosd.css.nix {config = config;}).style;
      };

      programs.niri = {
        package = config.programs.niri.package;
        settings = import ./niri.conf.nix {
          lib = lib;
          config = config;
          pkgs = pkgs;
        };
      };

      programs.fuzzel = {
        enable = true;
        settings = import ./fuzzel.conf.nix {
          lib = lib;
          config = config;
        };
      };

      programs.waybar = {
        enable = true;
        settings = import ./waybar.conf.nix {};
        style = (import ./waybar.css.nix {config = config;}).style;
      };

      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects.overrideAttrs (final: prev: {
          buildInputs = prev.buildInputs ++ [pkgs.wayland-scanner];
        });
        settings = import ./swaylock.conf.nix {
          lib = lib;
          config = config;
        };
      };

      services.swayidle = let
        lockCmd = "${config.home-manager.users.${conf.username}.programs.swaylock.package}/bin/swaylock";
      in {
        enable = true;
        events = [
          {
            event = "lock";
            command = lockCmd;
          }
          {
            event = "before-sleep";
            command = lockCmd;
          }
        ];
      };

      services.mako = {
        enable = true;
        defaultTimeout = 5000;
        maxVisible = 3;
        font = "AlegreyaSans";
        backgroundColor = config.theme.base;
        borderColor = config.theme.muted;
        textColor = config.theme.text;
        borderSize = 1;
        borderRadius = 8;
        icons = false;
      };
    };
  }
