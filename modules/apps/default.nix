{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkForce;
  inherit (config) conf;
  mkXwlWrapper = import ../niri/xwl-wrapper.nix;
  time = pkgs.makeDesktopItem {
    name = "peaclock-desktop";
    desktopName = "Time";
    exec = "alacritty -e ${pkgs.peaclock}/bin/peaclock";
  };
in
  mkIf (conf.host != "server") {
    # Audio
    security.rtkit.enable = true;

    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = mkForce false;
      };
      # Needed for some features in nautilus such as auto-mounting and trash
      gvfs.enable = true;
    };

    # Run statically linked and more
    environment.systemPackages = [pkgs.nix-alien];
    programs.nix-ld.enable = true;

    # Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    # Regularly clean download folder
    systemd = {
      timers."clean-download" = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*-*-* 03:00:00";
          Unit = "clean-download.service";
        };
      };

      services."clean-download" = {
        script = ''
          ${pkgs.coreutils}/bin/rm -rf /home/${conf.username}/Downloads/*
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };

    services.blueman.enable = true;

    home-manager.users.${conf.username} = {
      home = {
        packages = with pkgs;
          [
            adwaita-icon-theme
            adwaita-qt
            adwaita-qt6
            loupe
            spotify
            amberol
            signal-desktop
            vesktop
            snapshot
            nautilus
            inkscape
            libresprite
            gnome-disk-utility
            fragments
            element-desktop
            tor-browser
            libreoffice-qt6
            chromium
            peaclock
            fractal
            element-desktop
            papers
          ]
          ++ [
            time
          ]
          ++ [
            (mkXwlWrapper {
              pkgs = pkgs;
              name = "Prusa";
              pkg = "prusa-slicer";
            })
          ];

        file = {
          ".config/vesktop/settings.json" = {
            source = ./vesktop.conf.json;
          };
          ".config/vesktop/settings/settings.json" = {
            source = ./vencord.conf.json;
          };
        };

        pointerCursor = import ./cursor.nix pkgs;
      };

      qt = {
        enable = true;
        platformTheme.name = "adwaita";
        style.name = "adwaita-dark";
      };

      gtk = {
        enable = true;
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
        gtk2.extraConfig = "gtk-application-prefer-dark-theme=1\n";
        theme.name = "Adwaita Dark";
      };

      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      };

      programs = {
        firefox = import ./firefox.conf.nix pkgs;

        thunderbird = {
          enable = true;
          profiles = {
            "default" = {
              isDefault = true;
            };
          };
        };

        mpv.enable = true;

        pandoc.enable = true;

        alacritty = {
          enable = true;
          settings = import ./alacritty.conf.nix config;
        };
      };
    };
  }
