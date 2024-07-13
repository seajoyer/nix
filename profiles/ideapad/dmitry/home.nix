{ inputs, config, pkgs, lib, ... }:

{
    imports = let
        home = ../../../home;
    in [
        home/editors
        home/fonts
        home/pkgs
        home/programs
        home/services
        home/terminal

        home/services/udiskie.nix
        home/services/polkit-agent.nix
    ];

    options.my =
        let
            scaleFactor = 1.0;    # UI scale factor
            wallpaper   = xdg.userDirs.pictures/Wallpapers/current.png;
        in {
            adjust = lib.mkOption {
                type = lib.types.functionTo lib.types.int;
                default = x: let
                    ceil  = builtins.ceil  (x * scaleFactor);
                    floor = builtins.floor (x * scaleFactor);
                in if (x - floor) < (ceil - x) then floor else ceil;
                description = "A custom scale-adjusting function";
            };

            wallpaper = lib.mkOption {
                type = lib.types.path;
                default = wallpaper;
                description = "A currently installed background";
            };
        };

    config = {
        home = {
            username = "dmitry";
            homeDirectory = "/home/dmitry";
            stateVersion = "24.05";
        };

        nix.gc = {
            automatic = true;
            frequency = "weekly";
            options   = "--delete-older-than 30d";
        };

        # home.packages = with pkgs; [
        #     inputs.ags.packages.${pkgs.system}.ags
        #     # ags-related
        #     bun
        #     dart-sass
        #     matugen
        #     bun
        #     fd
        # ];

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
    };
}
