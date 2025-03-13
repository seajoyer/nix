{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  home.packages = with pkgs; [
    qt6.qtwayland
    qt6.qtwebengine
    libsForQt5.qt5.qtwebengine
  ];
}
