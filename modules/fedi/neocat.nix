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
    hash = "sha256-TLgD6uSBwVurIhvViAyOoVLnylmDq+H4obPKjCDbjoE=";
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
