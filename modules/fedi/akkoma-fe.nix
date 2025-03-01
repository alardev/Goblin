{
  runCommand,
  akkoma-frontends,
  xorg,
}:
runCommand "akkoma-fe" {
  nativeBuildInputs = [xorg.lndir];
} ''
  mkdir $out
  lndir ${akkoma-frontends.akkoma-fe} $out

  rm $out/static/styles.json
  cp ${./styles.json} $out/static/styles.json
''
