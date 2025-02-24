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
    cp 512w/*.png $out

    runHook postInstall
  '';
}
