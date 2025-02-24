{
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "blobhajFlags";
  version = "1.0";

  src = fetchurl {
    url = "https://heatherhorns.com/BlobhajFlags.zip";
    hash = "";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp 512w/*.png $out

    runHook postInstall
  '';
}
