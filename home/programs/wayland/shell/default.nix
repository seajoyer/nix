{ pkgs, ... }:

{
  imports = [
    ./noctalia
    # ./caelestia
    # ./dank
    # ./ambxst
  ];

  home.packages = with pkgs; [
    quickshell
  ];

  programs = {
  };
}
