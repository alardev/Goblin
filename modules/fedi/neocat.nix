{
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "blobs.gg";
  version = "unstable-2019-07-24";

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
