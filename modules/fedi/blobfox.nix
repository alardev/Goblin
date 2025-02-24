{
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "blobfox";
  version = "2020.09.04";

  src = fetchurl {
    url = "https://volpeon.ink/emojis/blobfox/blobfox.zip";
    hash = "sha256-mTLPzI5J8h9jLqVYfkY9wCO2our/sccK8wrsZgmr+ro=";
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
