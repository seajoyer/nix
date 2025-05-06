{ pkgs, ... }:

{
  imports = [ ./git.nix ./xdg.nix ./btop.nix ./vifm ./ssh ];

  home.packages = with pkgs; [
    # tops
    # nvtopPackages.nvidia
    batmon

    # tools
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
    unimatrix
    fastfetch
    tty-clock
    neofetch
    cbonsai
    pfetch
    cowsay
    # cava
  ];
}
