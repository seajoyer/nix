{
  pkgs,
  lib,
  config,
  ...
}:

lib.mkIf config.my.terminal.ghostty.enable {
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    package = pkgs.ghostty;

    settings = {
      font-family = "JetBrainsMono Nerd Font Propo";
      font-size   = 12;

      copy-on-select = "clipboard";
      background-opacity = 0.8;
      window-width = 1200;
      window-height = 742;
      window-padding-x = 10;
      window-padding-y = 8;
      cursor-style = "bar";
      background-blur = true;
      background = "000000";
      confirm-close-surface = false;
      shell-integration-features = true;

      config-file = "${config.home.homeDirectory}/.config/ghostty/themes/noctalia";

      # keybind = [
      #   "ctrl+alt+h=goto_split:left"
      #   "ctrl+alt+j=goto_split:down"
      #   "ctrl+alt+k=goto_split:up"
      #   "ctrl+alt+l=goto_split:right"
      # ];
    };
  };
}
