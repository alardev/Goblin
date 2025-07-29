{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkForce;
  inherit (config) conf;
  mkXwlWrapper = import ../niri/xwl-wrapper.nix;
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
    environment.systemPackages = [
      pkgs.nix-alien
      pkgs.umu-launcher
    ];
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

    services.blueman.enable = true;

    home-manager.users.${conf.username} = {
      home = {
        packages = with pkgs; [
          adwaita-icon-theme
          adwaita-qt
          adwaita-qt6
          loupe
          #spotify
          amberol
          #signal-desktop
          #vesktop
          snapshot
          nautilus
          inkscape
          libresprite
          gnome-disk-utility
          fragments
          telegram-desktop_git
          proton-ge-custom
          #tor-browser
          #libreoffice-qt6
          #ungoogled-chromium
          wayland_git
          wayland-protocols_git
          gh
          hunspell
          hunspellDicts.uk_UA
          hunspellDicts.en_GB-ize
          hunspellDicts.et_EE
          nero-umu
          bottles
          #peaclock
          #fractal
          #element-desktop
          #papers
          cyme
          pciutils
          ch341eeprom
          imsprog
          flashrom
          rustdesk
          unzrip
          # orca-slicer
          caligula
          umu-launcher
          ntfs3g
          hw-probe
          iw
          wpa_supplicant
          wpa_supplicant_gui
        ];

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
        chromium = import ./chromium.conf.nix pkgs;

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

        wezterm = {
          enable = true;
          #settings = import ./wezterm.conf.nix config;
        };
      };
    };
  }
