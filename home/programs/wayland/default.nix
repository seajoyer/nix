{ pkgs, ... }:

# Wayland config
{
  imports = [
    # ./hyprland
    ./niri
    ./shell
    ./hyprlock.nix
    ./wlogout.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp
    wayshot

    wayscriber
    wev

    # color picker
    hyprpicker

    # utils
    wl-ocr
    wl-clipboard
    wl-screenrec
    wlr-randr
    wtype

    # brightness
    brightnessctl
    brillo
  ];

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM  = "wayland";
    SDL_VIDEODRIVER  = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
