{
  pkgs,
  inputs,
  ...
}: {
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
          builders-use-substitutes = true;
          extra-substituters = [
            "https://anyrun.cachix.org"
            "https://cache.garnix.io"
          ];

          extra-trusted-public-keys = [
            "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          ];
      };
    };
  
  nixpkgs = {
    overlays = [
      inputs.nur.overlays.default
      inputs.niri.overlays.niri
      inputs.nix-alien.overlays.default
      inputs.umu.overlays.default
    ];
  };
  environment.systemPackages = [inputs.alejandra.defaultPackage.${pkgs.system}];
}
