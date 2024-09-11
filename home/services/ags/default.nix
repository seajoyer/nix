{ inputs, pkgs, lib, config, ... }:
let
  requiredDeps = with pkgs; [
    config.wayland.windowManager.hyprland.package
    bash
    fd
    bun
    matugen
    coreutils
    dart-sass
    gawk
    imagemagick
    procps
    ripgrep
    util-linux
    pipewire
    bluez
    bluez-tools
    grimblast
    gpu-screen-recorder
    wl-screenrec
    hyprpicker
    btop
    networkmanager
    brightnessctl
    gnome.gnome-bluetooth
    python312Packages.gpustat
  ];

  guiDeps = with pkgs; [
    gnome.gnome-bluetooth
    gnome.gnome-control-center
    mission-center
    overskride
    wlogout
  ];

  dependencies = requiredDeps ++ guiDeps;

  cfg = config.programs.ags;
in {
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = dependencies;

  programs.ags.enable = true;

  systemd.user.services.ags = {
    Unit = {
      Description = "Aylur's Gtk Shell";
      PartOf = [ "tray.target" "graphical-session.target" ];
    };
    Service = {
      Environment = "PATH=${lib.makeBinPath dependencies}";
      ExecStart = "${cfg.package}/bin/ags";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
