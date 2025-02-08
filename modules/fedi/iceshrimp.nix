{ fetchFromGitea, buildDotnetModule }: let
  ver = "v2024.1-beta4.security2";
in buildDotnetModule rec {
  pname = "iceshrimp";
  version = ver;

  src = fetchFromGitea {
    domain = "iceshrimp.dev";
    owner = "iceshrimp";
    repo = "Iceshrimp.NET";
    rev = ver;
    hash = "";
  };
}
