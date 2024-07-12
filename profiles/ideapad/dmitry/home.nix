{ inputs, config, pkgs, lib, ... }:

{
    imports = [
        ./profiles/ideapad
        ./hosts/ideapad
    ];

    # options.my =
    #     let
    #         scaleFactor = 1.0;    # UI scale factor
    #         wallpaper   = xdg.userDirs.pictures/Wallpapers/current.png;
    #     in {
    #         adjust = lib.mkOption {
    #             type = lib.types.functionTo lib.types.int;
    #             default = x: let
    #                 ceil  = builtins.ceil  (x * scaleFactor);
    #                 floor = builtins.floor (x * scaleFactor);
    #             in if (x - floor) < (ceil - x) then floor else ceil;
    #             description = "A custom scale-adjusting function";
    #         };

    #         wallpaper = lib.mkOption {
    #             type = lib.types.path;
    #             default = wallpaper;
    #             description = "A currently installed background";
    #         };
    #     };

    # config = with config.my; {
    #     # Home Manager needs a bit of information about you and the paths it should
    #     # manage.
    #     home.username = "dmitry";
    #     home.homeDirectory = "/home/dmitry";

    #     # This value determines the Home Manager release that your configuration is
    #     # compatible with. This helps avoid breakage when a new Home Manager release
    #     # introduces backwards incompatible changes.
    #     #
    #     # You should not change this value, even if you update Home Manager. If you do
    #     # want to update the value, then make sure to first check the Home Manager
    #     # release notes.
    #     home.stateVersion = "24.05"; # Please read the comment before changing.

    #     # The home.packages option allows you to install Nix packages into your
    #     # environment.
    #     home.packages = with pkgs; [
    #         telegram-desktop
    #         onlyoffice-bin
    #         font-manager
    #         bottles
    #         firefox
    #         nomacs

    #         nix-prefetch-git
    #         nix-prefetch-github

    #         wlogout

    #         brightnessctl
    #         fusuma

    #         hyprshade
    #         swww
    #         inputs.ags.packages.${pkgs.system}.ags
    #         # ags-related
    #         bun
    #         dart-sass
    #         matugen
    #         bun
    #         fd


    #         neovim
    #         vim

    #         btop

    #         alacritty
    #         ripgrep
    #         killall
    #         clipse
    #         unzip
    #         curl
    #         wget
    #         tree
    #         bat

    #         vifm

    #         tty-clock
    #         fastfetch
    #         neofetch
    #         pfetch
    #         cowsay
    #         cava
    #         unimatrix

    #         (nerdfonts.override {
    #             fonts = [
    #                 "NerdFontsSymbolsOnly"
    #                 "JetBrainsMono"
    #                 "Iosevka"
    #             ];
    #         })
    #         inter
    #         # noto-fonts
    #         # noto-fonts-cjk
    #         # noto-fonts-emoji
    #         # jetbrains-mono
    #         # fira-code-nerdfont
    #         # fira-code-symbols
    #         # fira
    #         iosevka-comfy.comfy-motion
    #         cascadia-code
    #     ];

    #     fonts.fontconfig.enable = true;

    #     home.pointerCursor = {
    #         package = pkgs.bibata-cursors;
    #         name = "Bibata-Modern-Classic";
    #         size = adjust 24;
    #         gtk.enable = true;
    #         x11.enable = true;
    #     };

    #     # home.sessionVariables = with config.xdg; {
    #     #     VAR1 = foo
    #     #     VAR2 = ...
    #     # };

    #     programs.kitty = {
    #         enable = true;
    #         font = {
    #             name = "JetBrainsMono Nerd Font Propo";
    #             size = adjust 14;
    #         };
    #         settings = {
    #             copy_on_select = true;
    #             strip_trailing_spaces = "smart";
    #             enable_audio_bell  = false;
    #             background_opacity = "0.8";
    #             dynamic_background_opacity = true;
    #             remember_window_size  = false;
    #             initial_window_width  = 1200;
    #             initial_window_height = 742;
    #             window_padding_width  = "0 10 0";
    #             confirm_os_window_close = 2;
    #             close_on_child_death = true;
    #             allow_remote_control = true;
    #             cursor_shape = "beam";
    #         };
    #         keybindings = {
    #             "kitty_mod+a>m" = "set_background_opacity +0.1";
    #             "kitty_mod+a>l" = "set_background_opacity -0.1";
    #             "kitty_mod+a>1" = "set_background_opacity 1";
    #             "kitty_mod+a>0" = "set_background_opacity 0";
    #             "kitty_mod+a>d" = "set_background_opacity default";
    #         };
    #         theme = "Catppuccin-Mocha";
    #         # Also available: Catppuccin-Frappe Catppuccin-Latte Catppuccin-Macchiato Catppuccin-Mocha
    #     };

    #     programs.zsh = {
    #         enable = true;
    #         enableCompletion = true;
    #         autosuggestion.enable = true;
    #         syntaxHighlighting.enable = true;
    #         history = {
    #             path = "${config.xdg.dataHome}/zsh/zsh_history";
    #             save = 100000;
    #             size = 1000;
    #         };
    #         oh-my-zsh = {
    #             enable = true;
    #             theme = "robbyrussell";
    #             plugins = [
    #                 "git"
    #             ];
    #         };
    #         shellAliases = {
    #             c = "clear";
    #             nu = "sudo nixos-rebuild switch --flake ~/nixHome";
    #             hu = "home-manager       switch --flake ~/nixHome";
    #         };
    #     };

    #     programs.git = {
    #         enable = true;
    #         userName  = "dasidiuk";
    #         userEmail = "imgarison@gmail.com";
    #     };


    #     # programs.ags = {
    #     #     enable = true;

    #     #     # null or path, leave as null if you don't want hm to manage the config
    #     #     configDir = ./ags;

    #     #     # additional packages to add to gjs's runtime
    #     #     extraPackages = with pkgs; [
    #     #         gtksourceview
    #     #         webkitgtk
    #     #         accountsservice
    #     #     ];
    #     # };

    #     gtk = {
    #         enable = true;
    #         cursorTheme = {
    #             name = "Bibata-Modern-Classic";
    #             package = pkgs.bibata-cursors;
    #         };
    #         theme = {
    #             package = pkgs.adw-gtk3;
    #             name = "adw-gtk3-dark";
    #         };
    #         iconTheme = {
    #             package = pkgs.gnome.adwaita-icon-theme;
    #             name = "Adwaita";
    #         };
    #         font = {
    #             name = "Inter";
    #             size = adjust 12;
    #         };
    #     };

    #     qt = {
    #         enable = true;
    #         platformTheme = {
    #             name = "gtk";
    #         };
    #         style = {
    #             name = "adwaita-dark";
    #             package = pkgs.adwaita-qt;
    #         };
    #     };

    #     xdg = {
    #         enable = true;
    #         userDirs.enable = true;

    #         mimeApps.defaultApplications = {
    #             "application/pdf" = [ "zathura.desktop" ];
    #         };

    #         configFile = with config.xdg; {
    #             "bat/config".text = ''
    #           --theme="Nord"
    #           --italic-text=always
    #           --map-syntax='.ignore:Git Ignore'
    #         '';
    #         };
    #     };

    #     nix.gc = {
    #         automatic = true;
    #         frequency = "weekly";
    #         options   = "--delete-older-than 30d";
    #     };

    #     services = {
    #         udiskie.enable = true;
    #     };

    #     # systemd.user = {
    #     #     services = {
    #     #         polkit-gnome-authentication-agent-1 = {
    #     #             description = "polkit-gnome-authentication-agent-1";
    #     #             wantedBy = [ "graphical-session.target" ];
    #     #             wants = [ "graphical-session.target" ];
    #     #             after = [ "graphical-session.target" ];
    #     #             serviceConfig = {
    #     #                 Type = "simple";
    #     #                 ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #     #                 Restart = "on-failure";
    #     #                 RestartSec = 1;
    #     #                 TimeoutStopSec = 10;
    #     #             };
    #     #         };
    #     #     };
    #     # };

    #     # Let Home Manager install and manage itself.
    #     programs.home-manager.enable = true;
    # };
}
