{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev:
    {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
      });
    })
  ];

  home.packages = with pkgs; [
    ags
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
    # python312Packages.gpustat
    gnome.gnome-control-center
    mission-center
    overskride
    wlogout
  ];
}	
	
	
	

	
	
	

	
	
	
	
	
	
	
	
	
	

	
	

	
	
	

	
	
	

	
	
	
	
	
	
	
