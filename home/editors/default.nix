{ pkgs, ... }:

{
  imports = [ ./emacs ./vim ];

  home.packages = with pkgs; [
    libgcc
    clang
    clang-tools
    cmake
    gnumake
    texliveMedium

    (python3.withPackages (ps:
      with ps; [
        numpy
        pandas
        pyright
        matplotlib
        jupyter
        pytest
        nose
        pyflakes
      ]))
  ];
}
