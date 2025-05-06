{ pkgs, ... }:

{
  imports = [
    ./emulators/kitty.nix
    ./shell/zsh.nix
    ./programs
  ];

  home.packages = with pkgs; [
    nushell
  ];
}
