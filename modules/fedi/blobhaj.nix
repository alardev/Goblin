{
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "blobhaj";
  version = "13.12.2022";

  src = ./blobhaj;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.png $out

    runHook postInstall
  '';
}
