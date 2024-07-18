{ pkgs, ... }:

{
  imports = [ ./git.nix ./xdg.nix ./vifm ];

  home.packages = with pkgs; [
    # tops
    nvtopPackages.nvidia
    batmon
    btop

    # tools
    ripgrep
    killall
    clipse
    unzip
    gols
    curl
    wget
    tree
    bat
    bc

    # fancy
    unimatrix
    fastfetch
    tty-clock
    neofetch
    pfetch
    cowsay
    cava
  ];
}
