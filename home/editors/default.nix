{ pkgs, ... }:

{
  imports = [ ./emacs ./vim ];

  home.packages = with pkgs; [
    direnv
    ngrok
    nssTools
    mkcert

    jdk
    libgcc
    clang
    clang-tools
    cmake

    gnumake
    sfml

    texliveFull
    texlab

    fira-code
    roboto

    (python3.withPackages (ps:
      with ps; [
        distro
        notebook
        numpy
        tabulate
        matplotlib
        seaborn
        scikit-learn
        pandas
        scipy
        # torch-bin
        # torchvision-bin
      ]))
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
