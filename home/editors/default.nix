{ pkgs, ... }:

{
  imports = [ ./emacs ./vim ];

  home.packages = with pkgs; [
    direnv
    ngrok

    libgcc
    clang
    clang-tools
    cmake
    gnumake

    texliveFull

    nodejs
    yarn

    # python3
    # python3Packages.numpy
    # python3Packages.pandas
    # python3Packages.pyright
    # python3Packages.matplotlib
    # python3Packages.jupyter
    # python3Packages.pytest
    # python3Packages.nose
    # python3Packages.pyflakes
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
