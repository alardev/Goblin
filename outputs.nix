{
  nixpkgs,
  lix,
  home-manager,
  nixos-hardware,
#  disko,
  niri,
  ironbar,
  anyrun,
#  lanzaboote,
  ...
} @ inputs: let
  modules = [
    ./options.nix
    ./modules
    lix.nixosModules.default
    niri.nixosModules.niri
    home-manager.nixosModules.home-manager
    #lanzaboote.nixosModules.lanzaboote
    #disko.nixosModules.disko
  ];
in {
  nixosConfigurations = {
    # Framework Laptop 16
    # AMD Ryzen 5 7840HS
    # AMD Radeon 780M
    # 64GB RAM
    goblet = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules =
        [
          ./devices/goblet
          nixos-hardware.nixosModules.framework-16-7040-amd
        ]
        ++ modules;
    };

    # ellaca = nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   specialArgs = {
    #     inherit inputs;
    #   };
    #   modules =
    #     [
    #       ./devices/ellaca
    #     ]
    #     ++ modules;
    # };
  };

  homeManagerConfigurations.goblet = inputs.hm.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        # And add the home-manager module
        inputs.ironbar.homeManagerModules.default
        {
          # And configure
          programs.ironbar = {
            enable = true;
          };
        }
      ];
  };
}
