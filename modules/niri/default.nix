{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) conf theme;
  cfg = config.conf.niri;
in
  mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    services.greetd = {
      enable = true;
      settings = import ./greetd.nix pkgs config;
    };

    programs.regreet.enable = true;

   # programs.ironbar = {
   #    enable = true;
   #    package = inputs.ironbar;
   #    # dfeatures = ["feature" "another_feature"];
   #  };
    
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
        wl-clipboard-rs
        anyrun
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


    # programs.anyrun = {
    #   enable = true;
    #   package = pkgs.anyrun;
    #   config = {
    #     x = { fraction = 0.5; };
    #     y = { fraction = 0.3; };
    #     width = { fraction = 0.3; };
    #     hideIcons = false;
    #     ignoreExclusiveZones = false;
    #     layer = "overlay";
    #     hidePluginInfo = false;
    #     closeOnClick = false;
    #     showResultsImmediately = false;
    #     maxEntries = null;

    #     plugins = [
    #       # An array of all the plugins you want, which either can be paths to the .so files, or their packages
    #       inputs.anyrun.packages.${pkgs.system}.applications
    #       "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"
    #     ];
    #   };
    # };


      # programs.ironbar = {
      #   enable = true;
      #   # settings = import ./waybar.conf.nix {};
      #   # style = (import ./waybar.css.nix {config = config;}).style;
      # };

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
        backgroundColor = theme.base;
        borderColor = theme.muted;
        textColor = theme.text;
        borderSize = 1;
        borderRadius = 8;
        icons = false;
      };
    };
  }
