{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # screenshot
    grim slurp wayshot

    # OCR
    wl-ocr

    # clipboard / recording
    wl-clipboard wl-screenrec

    # display / input inspection
    wlr-randr wtype wev wayscriber

    # color picker
    hyprpicker

    # brightness (userspace wrapper; brillo itself is system-level)
    brightnessctl brillo

    # wallpaper daemon
    awww
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORM  = "wayland";
    SDL_VIDEODRIVER  = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  home.file.".config/electron-flags.conf".text = ''
    --ozone-platform-hint=auto
    --enable-features=WaylandWindowDecorations
    --ozone-platform=wayland
  '';
}
