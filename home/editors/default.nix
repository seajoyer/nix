{ pkgs, ... }:

{
  imports = [ ./emacs ./vim ];

  home.packages = with pkgs; [
    texliveMedium

    (python3.withPackages (ps:
      with ps; [
        numpy
        pandas
        matplotlib
        jupyter
        pytest
        nose
        pyflakes
      ]))
  ];
}
