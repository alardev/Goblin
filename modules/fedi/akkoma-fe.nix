{
  runCommand,
  akkoma-frontends,
  jq,
  xorg,
}:
runCommand "akkoma-fe" {
  styles = builtins.readFile ./styles.json;
  nativeBuildInputs = [jq xorg.lndir];
  passAsFile = ["styles"];
} ''
  mkdir $out
  lndir ${akkoma-frontends.akkoma-fe} $out

  rm $out/static/styles.json
  cp ${styles} $out/static/
''
