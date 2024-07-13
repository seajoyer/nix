{ pkgs, self, ... }:

# Wayland config
{
  imports = [
    ./hyprland
    ./hyprlock.nix
    ./wlogout.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # utils
    wl-ocr
    wl-clipboard
    wl-screenrec
    wlr-randr

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
