{ lib, ... }:

{
  imports = [
    ./zsh.nix
    ./git.nix
    ./ssh.nix
    ./tools.nix
    ./vifm
  ];

  options.my.shell = {
    zsh.enable   = lib.mkEnableOption "zsh with oh-my-zsh";
    git.enable   = lib.mkEnableOption "git + gh config";
    ssh.enable   = lib.mkEnableOption "SSH config and key generation";
    tools.enable = lib.mkEnableOption "CLI tools (ripgrep, bat, etc.)";
    vifm.enable  = lib.mkEnableOption "vifm file manager";
  };
}
