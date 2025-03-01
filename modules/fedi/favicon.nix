{stdenv}: stdenv.mkDerivation {
  name = "favicon.png";
  src = ../../icons/favicon/favicon.png;

  dontUnpack = true;
  installPhase = ''
    cp $src $out
  '';
}
