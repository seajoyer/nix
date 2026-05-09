{ lib, config, pkgs, ... }:

lib.mkIf config.my.editors.zed.enable {
  programs.zed-editor = {
    enable  = true;
    package = pkgs.zed-editor-fhs;
  };
}
