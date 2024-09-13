{ pkgs, ... }:

{
  imports = [ ./git.nix ./xdg.nix ./btop.nix ./vifm ./ssh.nix ];

  home.packages = with pkgs; [
    # tops
    nvtopPackages.nvidia
    batmon

    # tools
    ripgrep
    killall
    clipse
    unzip
    p7zip
    gols
    curl
    wget
    tree
    zulu
    bat
    bc

    # fancy
    unimatrix
    fastfetch
    tty-clock
    neofetch
    cbonsai
    pfetch
    cowsay
    cava
  ];
}
