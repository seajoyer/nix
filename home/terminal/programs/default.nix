{ pkgs, ... }:

{
  imports = [ ./git.nix ./xdg.nix ./btop.nix ./vifm ./ssh ./cava.nix ];

  home.packages = with pkgs; [
    # tops
    # nvtopPackages.nvidia
    batmon

    # tools
    ghostscript
    execline
    ripgrep
    killall
    clipse
    unzip
    p7zip
    sops
    gols
    curl
    wget
    tree
    # zulu
    bat
    jq
    bc

    # fancy
    asciiquarium
    unimatrix
    fastfetch
    tty-clock
    neofetch
    cbonsai
    pfetch
    cowsay
    pipes
  ];
}
