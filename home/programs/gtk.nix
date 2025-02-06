{ lib, pkgs, config, ... }:

with config.my; {
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = adjust 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    # iconTheme = {
    #     package = pkgs.morewaita-icon-theme;
    #     name = "MoreWaita";
    # };
    font = {
      name = "Inter";
      size = adjust 12;
    };
  };
}
