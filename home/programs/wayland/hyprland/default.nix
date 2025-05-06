{ config, lib, pkgs, inputs, ... }:

let
  cursor = "HyprBibataModernClassicSVG";

  launch_misc = pkgs.writeShellScriptBin "launch_misc" ''
    # Change directory to your shell project and launch it
    nix run /home/dmitry/configs/home/services/marble/shell/#marble &

    # launching pyprland
    pypr &

    # launching an gestures tool
    fusuma &

    # wallpaper
    swww-daemon &

    # launching a clipboard manager
    clipse -listen &

    hyprsunset -t 4000
    # exec-once = linux-enable-ir-emitter run
    # exec-once = nm-applet
    # exec-once = ianny
  '';

  # Improved wrapper scripts with error logging
  astal-launcher = pkgs.writeShellScriptBin "astal-launcher" ''
    #!/usr/bin/env bash

    # Export necessary environment variables that might be missing in Hyprland context
    export PATH=$PATH:${pkgs.nix}/bin

    # Run with full path and capture output/errors
    nix run /home/dmitry/configs/home/services/marble/shell/#astal -- -t launcher
  '';

  astal-powermenu = pkgs.writeShellScriptBin "astal-powermenu" ''
    #!/usr/bin/env bash

    # Export necessary environment variables that might be missing in Hyprland context
    export PATH=$PATH:${pkgs.nix}/bin

    # Run with full path and capture output/errors
    nix run /home/dmitry/configs/home/services/marble/shell/#astal -- -t powermenu
  '';

in {
  imports = [ ./plugins ];

  home.packages = with pkgs; [
    bibata-hyprcursor
    astal-launcher
    astal-powermenu
  ];

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

      bind = SUPER,      R, exec, astal-launcher
      bind = SUPER, Escape, exec, astal-powermenu

      ${builtins.readFile ./hyprland.conf}

    '';
  };
}
