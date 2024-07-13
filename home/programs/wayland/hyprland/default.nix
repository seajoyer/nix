{ config, lib, pkgs, ... }:

let
  cursor = "HyprBibataModernClassicSVG";
  bibata-hyprcursor = pkgs.callPackage ../../../pkgs/bibata-hyprcursor {};

  launch_misc = pkgs.writeShellScriptBin "launc_misc" ''

# initializing an wallpaper daemon
swww init &

# setting up an wallpaper
swww img ${config.my.wallpaper}

# launching a clipboard manager
clipse -listen &

# launching bar, widgets, etc...
ags &

# launching an gestures tool
fusuma &

# exec-once = linux-enable-ir-emitter run
# exec-once = nm-applet
# exec-once = ianny
  '';

in {

  # Deps
  home.packages = with pkgs; [
    bibata-hyprcursor
  ];

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # load hyprcursor
  home.file."${config.xdg.dataHome}/icons/${cursor}".source = "${bibata-hyprcursor}/share/icons/${cursor}";

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''

exec-once = hyprpm reload -n

exec-once = hyprctl setcursor Bibata-Modern-Classic 24
# exec-once = hypridle
# exec-once = pypr
# exec-once = hyprshade auto

${builtins.readFile ./hyprland.conf}

    '';

    # plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
    #   # hyprbars
    #   # hyprexpo
    # ];
    };
}
