{ config, lib, pkgs, inputs, ... }:

let
  cursor = "HyprBibataModernClassicSVG";

  launch_misc = pkgs.writeShellScriptBin "launch_misc" ''
    # ags
    (ags -b hypr &)

    # launching emacs daemon
    killall emacs ; emacs --daemon &

    # launching pyprland
    pypr &

    # launching an gestures tool
    fusuma &

    # launching a clipboard manager
    clipse -listen &

    hyprsunset -t 4000
    # exec-once = linux-enable-ir-emitter run
    # exec-once = nm-applet
    # exec-once = ianny
  '';

in {
  imports = [ ./plugins ];

  home.packages = with pkgs; [ bibata-hyprcursor ];

  # xdg.portal = {
  #   enable = true;
  #   config.common.default = "*";
  #   extraPortals =
  #     [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  # };

  # load hyprcursor
  home.file."${config.xdg.dataHome}/icons/${cursor}".source =
    "${pkgs.bibata-hyprcursor}/share/icons/${cursor}";
  xdg.dataFile."icons/${cursor}".source =
    "${pkgs.bibata-hyprcursor}/share/icons/${cursor}";

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    extraConfig = ''

      # exec-once = hyprpm reload -n

      exec-once = bash ${launch_misc}/bin/launch_misc 2>${config.xdg.dataHome}/launch_misc.log

      exec-once = hyprctl setcursor Bibata-Modern-Classic 24

      ${builtins.readFile ./hyprland.conf}

    '';
  };
}
