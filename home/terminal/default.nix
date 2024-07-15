{ pkgs, ... }:

{
  imports = [
    ./emulators/kitty.nix
    ./shell/zsh.nix
    ./programs
  ];

  home.packages = with pkgs; [
    # emulators
    alacritty

    # tops
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
