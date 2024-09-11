{ lib, ... }: {
  programs.btop = {
    enable = true;
    settings = {
      color_theme = lib.mkForce "dracula";
      theme_background = false;
      vim_keys = true;
      update_ms = 1000;
    };
  };
}
