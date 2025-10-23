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
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    font = {
      name = "Inter";
      size = adjust 12;
    };

    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    gtk2.extraConfig = "gtk-application-prefer-dark-theme=1 ";
  };

  # Qt Theming
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    # platformTheme.name = "hyprqt6engine";
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  # Packages (with orchis theme override)
  home.packages = with pkgs; [
    qt6.qtwayland
    # libsForQt5.qtstyleplugins
    adwaita-icon-theme
    adwaita-qt
    gsettings-desktop-schemas
    glib
  ];
}
