{ rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, pipewire
, systemd
, seatd
, udev
, wayland
, libinput
, mesa
, libglvnd
}:

rustPlatform.buildRustPackage {
  pname = "niri";
  version = "unstable-2023-11-17";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "niri";
    rev = "19cafffe0f3f1eefc6984dc446134b0fd93d1e28";
    hash = "sha256-mDeJh3N6Zt3FNpyFmRkY8zOLIBad3CoV45WjB+RUkhA=";
  };


  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-1BEJEdmGCt6jtPEcBt4R1d/LdKWLLJYJpcOn4SbvkRk=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxkbcommon
    pipewire
    systemd
    seatd
    udev
    wayland
    libinput
    libglvnd
    mesa # libgbm
  ];

  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-Wl,--pop-state"
    "--release"
  ];

  postInstall =
  let
    niriSession = ''
      #!/bin/sh

      if [ -n "$SHELL" ] &&
         grep -q "$SHELL" /etc/shells &&
         ! (echo "$SHELL" | grep -q "false") &&
         ! (echo "$SHELL" | grep -q "nologin"); then
        if [ "$1" != '-l' ]; then
          exec bash -c "exec -l '$SHELL' -c '$0 -l $*'"
        else
          shift
        fi
      fi

      # Make sure there's no already running session.
      if systemctl --user -q is-active niri.service; then
        echo 'A niri session is already running.'
        exit 1
      fi

      # Reset failed state of all user units.
      systemctl --user reset-failed

      # Set the current desktop for xdg-desktop-portal.
      export XDG_CURRENT_DESKTOP=niri

      # Ensure the session type is set to Wayland for xdg-autostart apps.
      export XDG_SESSION_TYPE=wayland

      # Import the login manager environment.
      systemctl --user import-environment

      # DBus activation environment is independent from systemd. While most of
      # dbus-activated services are already using `SystemdService` directive, some
      # still don't and thus we should set the dbus environment with a separate
      # command.
      if hash dbus-update-activation-environment 2>/dev/null; then
          dbus-update-activation-environment --all
      fi

      # Start niri and wait for it to terminate.
      systemctl --user --wait start niri.service

      # Unset environment that we've set.
      systemctl --user unset-environment WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
    '';
    niriDesktop = ''
      [Desktop Entry]
      Name=Niri
      Comment=A scrollable-tiling Wayland compositor
      Exec=niri-session
      Type=Application
      DesktopNames=niri
      '';
    niriPortals = ''
      [preferred]
      default=gnome;gtk;
    '';
    niriService = ''
      [Unit]
      Description=A scrollable-tiling Wayland compositor
      BindsTo=graphical-session.target
      Before=graphical-session.target
      Wants=graphical-session-pre.target
      After=graphical-session-pre.target

      Wants=xdg-desktop-autostart.target
      Before=xdg-desktop-autostart.target

      [Service]
      Type=notify
      ExecStart=/usr/bin/niri
    '';
  in ''
      echo "${niriSession}" > $out/bin/niri-session
      mkdir -p $out/share/wayland-sessions
      echo "${niriDesktop}" > $out/share/wayland-sessions/niri.desktop
      mkdir -p $out/share/xdg-desktop-portal
      echo "${niriPortals}" > $out/share/wayland-sessions/niri-portals.conf
      mkdir -p $out/lib/systemd/user
      echo "${niriService}" > $out/lib/systemd/user/niri.service
    '';

  passthru.providedSessions = [ "niri" ];
}
