{stdenv}: {
  name = "favicon.png";
  src = ../../icons/favicon/favicon.png;

  dontUnpack = true;
  installPhase = ''
    mkdir -p $out
    cp favicon.png $out
  '';
}
