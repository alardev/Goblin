{
  stdenv,
  fetchFromGitea,
}: let
  version = "v2025.1-beta5.patch2.security1";
in
  stdenv.mkDerivation {
    name = "iceshrimp";
    src = fetchFromGitea {
      domain = "https://iceshrimp.dev";
      owner = "iceshrimp";
      repo = "Iceshrimp.NET";
      rev = version;
      hash = "";
    };

    installPhase = ''
      mkdir -p $out
      make
    '';
  }
