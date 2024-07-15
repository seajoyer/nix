{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    chromium

    libsForQt5.plasma-browser-integration
  ];
}
