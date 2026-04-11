{ lib, ... }:

{
  imports = [
    ./emacs
    ./vim
  ];

  options.my.editors = {
    emacs.enable = lib.mkEnableOption "Doom Emacs";
    vim.enable   = lib.mkEnableOption "Vim";
  };
}
