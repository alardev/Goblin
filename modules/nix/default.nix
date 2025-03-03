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
    };
  };

  nixpkgs = {
    overlays = [
      inputs.nur.overlays.default
      inputs.niri.overlays.niri
      inputs.nix-alien.overlays.default
    ];
  };
  environment.systemPackages = [inputs.alejandra.defaultPackage.${pkgs.system}];
}
