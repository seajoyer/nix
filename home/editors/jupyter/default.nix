{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jupyterjjj
    (python3.withPackages (ps: with ps; [
      numpy
      pandas
      matplotlib
    ]))
  ];
}
