{ pkgs, ... }:

{
  imports = [
    ./emulators/kitty.nix
    ./shell/zsh.nix
    ./programs
  ];
}
