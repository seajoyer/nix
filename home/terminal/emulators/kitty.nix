{ config, ... }:

with config.my; {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font Propo";
      size = adjust 14;
    };
    settings = {
      copy_on_select = true;
      strip_trailing_spaces = "smart";
      enable_audio_bell  = false;
      background_opacity = "0.8";
      dynamic_background_opacity = true;
      remember_window_size  = false;
      initial_window_width  = 1200;
      initial_window_height = 742;
      window_padding_width  = "0 10 0";
      confirm_os_window_close = 2;
      close_on_child_death = true;
      allow_remote_control = true;
      cursor_shape = "beam";
    };
    keybindings = {
      "kitty_mod+a>m" = "set_background_opacity +0.1";
      "kitty_mod+a>l" = "set_background_opacity -0.1";
      "kitty_mod+a>1" = "set_background_opacity 1";
      "kitty_mod+a>0" = "set_background_opacity 0";
      "kitty_mod+a>d" = "set_background_opacity default";
    };
    theme = "Catppuccin-Mocha";
    # Also available: Catppuccin-Frappe Catppuccin-Latte Catppuccin-Macchiato Catppuccin-Mocha
  };
}
