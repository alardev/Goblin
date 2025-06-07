{
  nixpkgs,
  home-manager,
  nixos-hardware,
  #  disko,
  chaotic,
  niri,
  lanzaboote,
  ...
} @ inputs: let
  modules = [
    ./options.nix
    ./modules
    niri.nixosModules.niri
    home-manager.nixosModules.home-manager
    lanzaboote.nixosModules.lanzaboote
    chaotic.nixosModules.default
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
  };

  homeConfigurations = {
    # ... other configs
    goblet = home-manager.lib.homeManagerConfiguration {
      # Replace "configName" with a significant unique name
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./home-manager/default.nix
        chaotic.homeManagerModules.default # IMPORTANT
      ];
    };
  };
}
