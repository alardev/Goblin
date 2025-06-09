# Goblin

My NixOS dotfiles for my goblinated Frankenwork 16 tablet and other devices.
Focuses on oxidizing userspace and kernel as much as goblinly possible.
It's an utterly autistic desktop rice, which is why I called it Goblin.

## Features
- Niri scrollable tiling WM
- Wezterm + Starship + Fish shell
- Lanzaboote disk encryption
- Anyrun application runner
- SwayOSD - GTK based on screen display for caps-lock volume etc
- wl-clipboard-rs
- evil-helix - helix fork that behaves more like nvim
- EWW bar (WIP)

## WIP:
The following need to be oxidized:
- Lockscreen (wlsleephandler-rs?)
- notifications (EWW?)
- wl-gammarelay-rs for display color temp and brightness
- woomer for zooming
- squeekboard for on-screen keyboard
- SWWW wallpaper service
- Regreet graphical greeter(login screen)

QoL Features:
- Picture-in-Picture mode
- keyboard layouts configured
- Xwayland-satellite integration with Niri for X11 dependent apps like Steam

## Other utilities and features
- uutils-coreutils-prefix - replace coreutils with rust ports
- fd - 
- zoxide
- zellij
- yazi
- gitui
- ripgrep-all
- tokei
- dust
- bacon
- fselect
- bat
- btm - bottom system monitor
- eza
- xh
- bacon
- just
- presenterm

## Credits
- [Mira (twooneis)](https://git.twoneis.site/mira/nix-config) - forked from her repo
- [SoraTenshi](https://github.com/SoraTenshi/nixos-config) - EWW config as a base template
- billions of other souls from whom I scavenged bits and bolts
