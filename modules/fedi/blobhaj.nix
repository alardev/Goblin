{
  stdenvNoCC,
  fetchurl,
  unzip,
}: let
  day = "13";
  month = "12";
  year = "2022";
in stdenvNoCC.mkDerivation rec {
  pname = "blobhaj";
  version = "${month}-${day}-${year}";

  src = fetchurl {
    url = "https://heatherhorns.com/wp-content/uploads/${year}/${month}/Blobhaj-${version}.zip";
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
