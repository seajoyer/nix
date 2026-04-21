{ pkgs, ... }:

{
  home.pointerCursor = {
    package    = pkgs.bibata-cursors;
    name       = "Bibata-Modern-Classic";
    size       = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # GTK theming is managed imperatively via nwg-look for now
  gtk = {
    enable = false;
    # colorScheme = "dark";
    # cursorTheme = {
    #   name = "Bibata-Modern-Classic";
    #   package = pkgs.bibata-cursors;
    # };
    # theme = {
    #   name = "adw-gtk3";
    #   package = pkgs.adw-gtk3;
    # };
    # iconTheme = {
    #   package = pkgs.papirus-icon-theme;
    #   name = "Papirus-Dark";
    # };
    # font = {
    #   name = "Inter";
    #   size = adjust 12;
    # };
    # gtk3 = {
    #   extraCss = "@import url('dank-colors.css');";
    # };

    # gtk4 = {
    #   extraCss = "@import url('dank-colors.css');";
    # };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    qt6Packages.qttools
    qt6Packages.qt5compat
    qt6Packages.qtwayland
    adwaita-icon-theme
    adwaita-qt
    gsettings-desktop-schemas
    adw-gtk3
    nwg-look
    glib
  ];
}
