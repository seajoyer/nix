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
    font = {
      name = "Inter";
      size = adjust 12;
    };

    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk2.extraConfig = "gtk-application-prefer-dark-theme=1 ";
  };

  home.packages = with pkgs; [ webkitgtk_6_0 gnome-themes-extra ];
}
