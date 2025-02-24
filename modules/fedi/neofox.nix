{
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "neofox";
  version = "2023.06.30";

  src = fetchurl {
    url = "https://volpeon.ink/emojis/neofox/neofox.zip";
    hash = "sha256-aZl+wc7Up7/iPSoim8RXV0pmO+cyjfMIg/36ZADQN0k=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.png $out

    runHook postInstall
  '';
}
