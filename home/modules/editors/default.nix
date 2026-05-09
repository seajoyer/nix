{ lib, ... }:

{
  imports = [
    ./emacs
    ./vim
    ./zed
  ];

  options.my.editors = {
    emacs.enable = lib.mkEnableOption "Doom Emacs";
    vim.enable   = lib.mkEnableOption "Neovim + Vim";
    zed.enable   = lib.mkEnableOption "Zed editor";
  };
}
