{ lib, config, pkgs, ... }:

lib.mkIf config.my.editors.neovim.enable {
  home.packages = with pkgs; [
    neovim
    vim
  ];
}
