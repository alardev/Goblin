{
  config,
  pkgs,
  ...
}: let
  inherit (config) conf;
  inherit (config.conf) keys;
in {
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  home-manager.users.${conf.username} = {
    home.packages = with pkgs; [
      man-pages
      man-pages-posix
      uutils-coreutils-noprefix
      ripgrep
      ripgrep-all
      fd
      bat
      bottom
      eza
      zoxide
      xh
      zellij
      gitui
      dust
      dua
      hyperfine
      bacon
      cargo-info
      fselect
      rusty-man
      delta
      tokei
      wiki-tui
      just
      mask
      mprocs
      presenterm
     # evil-helix_git
    ];

    home.file = {
      ".gdbinit" = {
        source = ./gdbinit.conf;
      };
    };

    programs.man = {
      enable = true;
    };

    programs.yazi.enable = true;

    programs.starship.enable = true;

    programs.less = {
      enable = true;
      keys = ''
        ${keys.up} back-line
        ${keys.down} forw-line
      '';
    };

    programs.git = {
      enable = true;
      userName = "alardev";
      userEmail = "alar.okas@protonmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    programs.helix = {
       enable = true;
       defaultEditor = true;
       extraPackages = with pkgs; [nil marksman];
       settings = import ./helix.conf.nix {config = config;};
       languages = import ./helix-languages.conf.nix {};
     };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    programs.bottom = {
      enable = true;
    };

    programs.hyfetch = {
      enable = true;
      settings = import ./hyfetch.conf.nix {};
    };

    programs.fish = {
      enable = true;

      plugins = [
        {
          name = "pure";
          src = pkgs.fishPlugins.pure.src;
        }
      ];

      functions = {
        run = {
          body = "nix run nixpkgs#$argv[1] -- $argv[2..]";
        };

        fish_prompt = {
          body = builtins.readFile ./prompt.fish;
        };
      };

      shellAbbrs = {
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gs = "git submodule sync --recursive && git submodule update --init --recursive";
        gpl = "git pull --recurse-submodules";
        gst = "git status";

        repl = "nix repl --expr 'import <nixpkgs>{}'";

        nrb = "sudo nixos-rebuild switch --cores 0 --flake .";
        nd = "nix develop";
      };
    };
  };
}
