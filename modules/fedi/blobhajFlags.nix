{stdenvNoCC}:
stdenvNoCC.mkDerivation {
  pname = "blobhajFlags";
  version = "1.0";

  src = ./blobhajFlags;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.png $out

    runHook postInstall
  '';
}
