{
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "neocat";
  version = "2023.08.10";

  src = fetchurl {
    url = "https://volpeon.ink/emojis/neocat/neocat.zip";
    hash = "";
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
