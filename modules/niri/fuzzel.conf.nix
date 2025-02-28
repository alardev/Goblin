{
  lib,
  config,
  ...
}: let
  inherit (lib.strings) concatStrings;
  inherit (config) theme;
in {
  main = {
    font = "FiraCodeNerdFont";
    dpi-aware = true;
    icons-enabled = false;
    terminal = "alacritty -e";
    prompt = "'󱄅 '";
  };
  colors = {
    background = concatStrings [theme.surface "ee"];
    prompt = concatStrings [theme.text "ff"];
    input = concatStrings [theme.text "ff"];
    text = concatStrings [theme.text "ff"];
    match = concatStrings [theme.gold "ff"];
    selection = concatStrings [theme.highlight-med "ee"];
    selection-text = concatStrings [theme.text "ff"];
    selection-match = concatStrings [theme.gold "ff"];
  };
  border = {
    width = 0;
    radius = 8;
  };
}
