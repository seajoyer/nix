{ config, pkgs, ... }:

let
  cursor = "HyprBibataModernClassicSVG";

  get-overrides = pkgs.writeScriptBin "get-overrides.fish" ''
    #!${pkgs.fish}/bin/fish
    ${builtins.readFile ../shell/caelestia/get-overrides.fish}
  '';

  monitor-config = pkgs.writeScriptBin "monitor-config.fish" ''
    #!${pkgs.fish}/bin/fish
    ${builtins.readFile ../shell/caelestia/monitor-config.fish}
  '';

  # Improved wrapper scripts with error logging
  # astal-launcher = pkgs.writeShellScriptBin "astal-launcher" ''
  #   #!/usr/bin/env bash

  #   # Export necessary environment variables that might be missing in Hyprland context
  #   export PATH=$PATH:${pkgs.nix}/bin

  #   nix run /home/dmitry/configs/home/services/marble/shell/#astal -- -t launcher
  # '';

  # astal-powermenu = pkgs.writeShellScriptBin "astal-powermenu" ''
  #   #!/usr/bin/env bash

  #   # Export necessary environment variables that might be missing in Hyprland context
  #   export PATH=$PATH:${pkgs.nix}/bin

  #   nix run /home/dmitry/configs/home/services/marble/shell/#astal -- -t powermenu
  # '';

  # astal-screenrecord = pkgs.writeShellScriptBin "astal-screenrecord" ''
  #   #!/usr/bin/env bash

  #   # Export necessary environment variables that might be missing in Hyprland context
  #   export PATH=$PATH:${pkgs.nix}/bin

  #   nix run /home/dmitry/configs/home/services/marble/shell/#screenrecord
  # '';

in
{
  imports = [ ./plugins ];

  home.packages = with pkgs; [
    bibata-hyprcursor
    hyprland-qt-support
  ];

  # load hyprcursor
  home.file."${config.xdg.dataHome}/icons/${cursor}".source =
    "${pkgs.bibata-hyprcursor}/share/icons/${cursor}";
  xdg.dataFile."icons/${cursor}".source = "${pkgs.bibata-hyprcursor}/share/icons/${cursor}";

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    settings = {
      # MONITORS
      monitor = [
        "eDP-1, highres, 0x0, 1.25"
        "HDMI-A-1, preferred, auto, 1.25, mirror, eDP-1"
      ];

      # DEBUG SETTINGS
      debug = {
        disable_logs = false;
      };

      # GENERAL SETTINGS
      general = {
        # layout = "scrolling";
        resize_on_border = 1;
        border_size = 2;
        gaps_out = 8;
        gaps_in = 5;

        "col.inactive_border" = "0xff304266";
        "col.active_border" = "0xbb8ab4f8";

        snap = {
          enabled = true;
          window_gap = 20;
          monitor_gap = 20;
        };
      };

      # CURSOR SETTINGS
      cursor = {
        inactive_timeout = 10;
      };

      # XWAYLAND SETTINGS
      xwayland = {
        force_zero_scaling = true;
        create_abstract_socket = true;
      };

      # WINDOW GROUP SETTINGS
      group = {
        "col.border_active" = "0xff9077E7";
        "col.border_inactive" = "0xff2E2E2F";
        "col.border_locked_active" = "0xff9077E7";
        "col.border_locked_inactive" = "0xff2E2E2F";

        groupbar = {
          enabled = 1;
          render_titles = 0;
          height = 1;
          priority = 10;
          "col.active" = "0xff9077E7";
          "col.inactive" = "0xffC5C5C5";
          "col.locked_active" = "0xff9077E7";
          "col.locked_inactive" = "0xffAA4C68";
        };
      };

      # DWINDLE LAYOUT SETTINGS
      dwindle = {
        preserve_split = 1;
      };

      # INPUT SETTINGS
      input = {
        numlock_by_default = 1;
        follow_mouse = 1;
        repeat_delay = 200;
        repeat_rate = 30;
        special_fallthrough = 1;
        kb_options = "grp:lalt_lshift_toggle,caps:escape_shifted_capslock";
        kb_layout = "us,ru";

        touchpad = {
          scroll_factor = 0.3;
          natural_scroll = 1;
          middle_button_emulation = 1;
        };
      };

      # GESTURE SETTINGS
      gestures = {
        gesture = "3, horizontal, workspace";
        workspace_swipe_direction_lock = 0;
        workspace_swipe_forever = 0;
      };

      # BINDING SETTINGS
      binds = {
        workspace_back_and_forth = 1;
        allow_workspace_cycles = 1;
      };

      # DECORATION SETTINGS
      decoration = {
        rounding = 10;
        rounding_power = 4.0;

        blur = {
          enabled = true;
          size = 7;
          passes = 4;
          ignore_opacity = true;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          xray = false;
          new_optimizations = true;
          popups = true;
        };

        # blur = {
        #   enabled = 1;
        #   new_optimizations = 1;
        #   ignore_opacity = 1;
        #   vibrancy_darkness = 0.5;
        #   special = 0;
        #   popups = 1;
        #   input_methods = 1;
        #   brightness = 1;
        #   contrast = 1;
        #   passes = 6;
        #   size = 3;
        #   xray = 1;
        # };

        shadow = {
          enabled = 1;
          range = 150;
          scale = 0.95;
          color = "0xaf1a1a1a";
          ignore_window = 1;
        };

        fullscreen_opacity = 1.0;
        inactive_opacity = 1.0;
        active_opacity = 1.0;
      };

      # ANIMATION SETTINGS
      animations = {
        enabled = 1;

        # Bezier Curves
        bezier = [
          "fast, 0.23, 0.94, 0.1, 1"
          "smooth, 0.05, 0.9, 0.1, 1.02"
          "linear, 0.0, 0.0, 1.0, 1.0"
        ];

        # Animation Settings
        animation = [
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "fadeOut, 1, 2, default"
          "workspaces, 1, 4, fast, slide"
          "specialWorkspace, 1, 2, fast, slidefadevert"
          "windowsIn, 1, 4, smooth"
          "windowsMove, 1, 3, smooth"
          "windowsOut, 1, 6, default, popin 80%"
          "borderangle, 1, 100, linear, loop"
        ];
      };

      # MISCELLANEOUS SETTINGS
      misc = {
        animate_mouse_windowdragging = 1;
        animate_manual_resizes = 1;
        # disable_hyprland_logo = 1;
        # disable_splash_rendering = 1;
        key_press_enables_dpms = 1;
        swallow_regex = "^(kitty)$";
        enable_swallow = 1;
        vrr = 2;
      };

      # WORKSPACE DEFINITIONS
      workspace = [
        "f[1], gapsout:0, gapsin:0, decorate:0, border:0"
        "f[0], gapsout:0, gapsin:0, decorate:0, border:0"
        # # "special:minimized, gapsin:20, gapsout:250, bordersize:4"
        "special:1, on-created-empty:[float] Telegram"
        "special:2, on-created-empty:[tile] emacs"
      ];

      # LAYER RULES
      layerrule = [
        "noanim, ^(dms)$"
      ];

      # WINDOW RULES
      windowrulev2 = [
        "float,      class:^(org.quickshell)$"
        "float,      initialTitle:^(Picture-in-Picture)$"
        "pin,        initialTitle:^(Picture-in-Picture)$"
        "float,      initialClass:^(org.gnome.Calculator)$"
        "noborder 1, onworkspace:w[t1]s[true]"
        "noborder 1, onworkspace:w[tv1]s[true]"
        "noborder 1, onworkspace:w[t1]s[false]"
        "noborder 1, onworkspace:w[tv1]s[false]"
        # Position Rules
        "move 1598 66,   initialTitle:^(org.gnome.Calculator)$"
        "move 1530 24,   initialClass:^(org.gnome.clocks)$"
        "move 1218 66,   initialTitle:^(Select a File)$"
        "move 138 67,    initialClass:^(firefox)$, title:^(Firefox — Sharing Indicator)$"
        "move 1628 76,   initialClass:^(protonvpn-app)$, title:^(Proton VPN)$"

        # Size Rules
        "size 800 494,   floating:1"
        "size 1618 1000, initialClass:^(org.telegram.desktop)$, title:^(Telegram)$"
        "size 400 600,   class:^(protonvpn-app)$, title:^(Proton VPN)$"
        "size 1133 700,  title:^(thunar)$"
        "size 1618 1000, title:^(emacs)$"
        "size 300 600,   initialTitle:^(org.gnome.Calculator)$"
        "size 494 800,   class:^(org.gnome.clocks)$"
        "size 800 494,   initialClass:^(kitty)$"
        "size 1618 1000, class:^(firefox)$"
        "size 1000 618,  class:(clipse)"

        # Appearance Rules
        "bordersize 0,   initialClass:^(clipse)$"
        "animation popin 80%, initialClass:^(clipse)$"

        # Float Rules
        "float, title:^(viewnior)$"
        "float, title:^(nwg-look)$"
        "float, title:^(Rofi)$"
        "float, title:^(thunar)$"
        "float, class:^(org.gnome.clocks)$"
        "float, class:^(org.gnome.Nautilus)$"
        "float, title:^(galculator)$"
        "float, title:^(eww)$"
        "float, title:^(pavucontrol)$"
        "float, title:^(nm-connection-editor)$"
        "float, title:^(blueberry.py)$"
        "float, title:^(org.gnome.Settings)$"
        "float, title:^(org.gnome.design.Palette)$"
        "float, title:^(Color Picker)$"
        "float, title:^(Network)$"
        "float, title:^(xdg-desktop-portal)$"
        "float, title:^(xdg-desktop-portal-gnome)$"
        "float, title:^(transmission-gtk)$"
        "float, title:^(.*exe)$"
        "float, title:^(feh)$"
        "float, title:^(Color Picker)$"
        "float, class:^(kitty-maple1)$, title:^(maple)$"
        "float, class:^(firefox)$, title:^(Picture-in-Picture)$"
        "float, class:^(firefox)$, title:^(Firefox — Sharing Indicator)$"
        "float, class:^(firefox)$, title:^(Extension.*)$"
        "float, title:^(Save File)$"
        "float, title:^(Open File)$"
        "float, title:^(Choose Files)$"
        "float, class:^(xdg-desktop-portal-gtk)$"
        "float, class:^(krita)$"
        "float, title:^(Picture in picture)$"
        "float, class:^(org.twosheds.iwgtk)$"
        "float, initialClass:^(org.telegram.desktop)$, title:(.*Mini App.*)"
        "float, initialClass:^(VirtualBox Manager)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(blueberry.py)$"
        "float, class:^(tflexcad.exe)$"
        "float, class:^(BasemarkGPU)$"
        "float, class:^(jamesdsp)$"
        "float, class:^(wlogout)$"
        "float, class:^(geeqie)$"
        "float, class:^(clipse)"

        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"

        "tile, class:^(neovide)$"

        # Topterm Rule
        "noborder 0, initialClass:^(topTerm)$"
      ];

      # PLUGIN CONFIGURATIONS
      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 15;
          bg_col = "rgb(111111)";
          workspace_method = "center curent";
          enable_gesture = false;
          gesture_distance = 300;
          gesture_positive = true;
        };
        hyprscrolling = {
          column_width = 0.7;
          fullscreen_on_one_column = false;
        };
      };

      # ENVIRONMENT VARIABLES
      env = [
        "XCURSOR_THEME, GoogleDot-Black"
        "XCURSOR_SIZE, 24"
        "HYPRCURSOR_THEME, Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE, 24"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "QT_QPA_PLATFORMTHEME,gtk3"
        "QT_QPA_PLATFORMTHEME_QT6,gtk3"
        "GDK_SCALE, 1"
        "GDK_BACKEND, wayland,x11"
        "CLUTTER_BACKEND, wayland"
        "LIBSEAT_BACKEND, logind"
        "_JAVA_AWT_WM_NONREPARENTING, 1"
        "MOZ_DISABLE_RDD_SANDBOX, 1"
        "MOZ_ENABLE_WAYLAND, 1"
        "XDG_SESSION_DESKTOP, Hyprland"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "SDL_VIDEODRIVER, wayland"
        "EGL_PLATFORM, wayland"
        "WLR_BACKEND, vulkan"
        "WLR_NO_HARDWARE_CURSORS, 1"
        "WLR_DRM_NO_MODIFIERS, 1"
        "SWWW_TRANSITION_FPS, 60"
        "QT_QUICK_CONTROLS_STYLE, org.hyprland.style"
      ];
    };

    # Add startup commands and import bindings through extraConfig
    extraConfig = ''
      # Import keybindings from separate file
      source = ~/configs/home/programs/wayland/hyprland/binds_general.conf

      exec-once = hyprctl setcursor Bibata-Modern-Classic 24

      # exec-once = linux-enable-ir-emitter run
      # exec-once = nm-applet
      # exec-once = ianny

      # caelestia-shell specific
      source = ~/configs/home/programs/wayland/hyprland/binds_caelestia.conf
      source = ~/.config/hypr/scheme/current.conf
      exec = ${get-overrides}/bin/get-overrides.fish
      source = ~/.config/hypr/overrides.conf
      exec-once = ${monitor-config}/bin/monitor-config.fish
      exec-once = clipse -listen &

      # dank-shell specific
      # source = ~/configs/home/programs/wayland/hyprland/binds_dms.conf
    '';
  };
}
