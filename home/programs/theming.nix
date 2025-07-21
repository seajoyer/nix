{ lib, pkgs, config, ... }:

with config.my; {
  # Cursor settings (preserved as-is)
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = adjust 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # GTK Theming (updated for Orchis with black and solid variants)
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    theme = {
      name = "Orchis-Grey-Dark";
      package = pkgs.orchis-theme.override { tweaks = [ "black" "solid" ]; };
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
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
    platformTheme.name = "adwaita";
    style.name = "adwaita";
  };

  # Packages (with orchis theme override)
  home.packages = with pkgs; [
    (orchis-theme.override { tweaks = [ "black" "solid" ]; })
    # Required for Qt/GTK compatibility
    qt6.qtwayland
    libsForQt5.qt5.qtwebengine
    libsForQt5.qtstyleplugins
    adwaita-icon-theme
    adwaita-qt
  ];
}
