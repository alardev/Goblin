{ pkgs, ... }: {
  qt = {
    enable = true;
    platformTheme = "gtk3";
    style.package = pkgs.adwaita-qt;
    style.name = "adwaita-dark";
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk2.extraConfig = "gtk-application-prefer-dark-theme=1\n";
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    theme.name = "Adwaita Dark";
  };
}
