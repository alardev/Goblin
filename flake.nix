{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";     
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #disko = {
    #  url = "github:nix-community/disko/latest";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nur = {
      url = "github:nix-community/nur";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #lanzaboote = {
    #  url = "github:nix-community/lanzaboote/v0.4.2";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
    };
  };

  outputs = inputs: import ./outputs.nix inputs;
}
