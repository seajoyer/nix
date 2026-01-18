{ pkgs, ... }:

{
  imports = [ ./emacs ./vim ];

  home.packages = with pkgs; [
    clang-tools

    direnv
    # ngrok
    nssTools
    mkcert

    jdk
    libgcc
    cmake

    gnumake
    sfml

    texliveFull
    texlab

    fira-code
    roboto

    nil

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

    devenv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
