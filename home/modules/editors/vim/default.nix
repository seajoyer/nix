{
  lib,
  config,
  pkgs,
  ...
}:

lib.mkIf config.my.editors.vim.enable {
  home.packages = with pkgs; [
    neovim
    vim
  ];
}
