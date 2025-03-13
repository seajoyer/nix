{ pkgs, ... }:

{
  imports = [ ./emacs ./vim ];

  home.packages = with pkgs; [
    vscode

    direnv
    ngrok
    nssTools
    mkcert

    libgcc
    clang
    clang-tools
    cmake

    code-cursor
    windsurf

    gnumake
    sfml

    texliveFull

    fira-code
    roboto

    (python3.withPackages (ps: with ps; [ distro ]))
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
