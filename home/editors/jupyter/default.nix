{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jupyter
    (python3.withPackages (ps: with ps; [
      numpy
      pandas
    ]))
  ];
}
