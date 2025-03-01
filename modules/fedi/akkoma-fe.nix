{
  runCommand,
  akkoma-frontends,
  xorg,
  jq,
}:
runCommand "akkoma_fe" {
  nativeBuildInputs = [xorg.lndir jq];
} ''
  mkdir $out
  lndir ${akkoma-frontends.akkoma-fe} $out

  rm $out/static/styles.json
  cp ${./styles.json} $out/static/styles.json

  rm $out/static/config.json
  jq -s add ${akkoma-frontends.akkoma-fe}/static/config.json ${./config.json} > $out/static/config.json

  cp ${../../icons/favicon/favicon.png} $out/static/logo.png

  cp ${./rosepine.json} $out/static/themes/rosepine.json
''
