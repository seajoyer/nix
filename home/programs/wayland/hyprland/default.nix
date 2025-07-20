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

in {
  imports = [ ./plugins ];

  home.packages = with pkgs;
    [
      bibata-hyprcursor
      # astal-launcher
      # astal-powermenu
      # astal-screenrecord
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
    settings = {
      # MONITORS
      monitor = [
        "eDP-1, highres, 0x0, 1.25"
        # "HDMI-A-1, preferred, auto, 1.25, mirror, eDP-1"
      ];

      # DEBUG SETTINGS
      debug = { disable_logs = false; };

      # GENERAL SETTINGS
      general = {
        "col.inactive_border" = "0xff304266";
        "col.active_border" = "0xbb8ab4f8";
        resize_on_border = 1;
        border_size = 3;
        gaps_out = 8;
        gaps_in = 5;

        snap = {
          enabled = true;
          window_gap = 20;
          monitor_gap = 20;
        };
      };

      # CURSOR SETTINGS
      cursor = { inactive_timeout = 10; };

      # XWAYLAND SETTINGS
      xwayland = { force_zero_scaling = true; };

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
      dwindle = { preserve_split = 1; };

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
        workspace_swipe = 1;
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

        blur = {
          enabled = 1;
          new_optimizations = 1;
          ignore_opacity = 1;
          vibrancy_darkness = 0.5;
          special = 0;
          popups = 1;
          input_methods = 1;
          brightness = 1;
          contrast = 1;
          passes = 6;
          size = 3;
          xray = 1;
        };

        shadow = {
          enabled = 1;
          ignore_window = 1;
          render_power = 4;
          color = "0xee000000";
          color_inactive = "0xaa000000";
          range = 70;
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
        key_press_enables_dpms = 1;
        swallow_regex = "^(kitty)$";
        enable_swallow = 1;
        vrr = 2;
      };

      # WORKSPACE DEFINITIONS
      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
        "special:minimized, gapsin:20, gapsout:250, bordersize:4"
        "special:1, on-created-empty:[float] Telegram"
        "special:2, on-created-empty:[float] emacsclient --create-frame"
      ];

      # WINDOW RULES
      windowrule = [
        # Position Rules
        "move 1598 66,   title:^(org.gnome.Calculator)$"
        "move 1530 24,   class:^(org.gnome.clocks)$"
        "move 1218 66,   title:^(Select a File)$"
        "move 138 67,    class:^(firefox)$, title:^(Firefox — Sharing Indicator)$"
        "move 1628 76,   class:^(protonvpn-app)$, title:^(Proton VPN)$"

        # Size Rules
        "size 800 494,   floating:1"
        "size 1618 1000, initialclass:^(org.telegram.desktop)$, title:^(Telegram)$"
        "size 400 600,   class:^(protonvpn-app)$, title:^(Proton VPN)$"
        "size 1133 700,  title:^(thunar)$"
        "size 1618 1000, title:^(emacs)$"
        "size 494 800,   class:^(org.gnome.clocks)$"
        "size 800 494,   initialclass:^(kitty)$"
        "size 1618 1000, class:^(firefox)$"
        "size 1000 618,  class:(clipse)"

        # Appearance Rules
        "rounding 10,    floating:1"
        "bordersize 1,   initialclass:^(clipse)$"
        "bordercolor rgba(00C9DFFF), title:^(.*Hyprland.*)$"
        "opacity 1.0 override 0.95 override, title:^(kitty)$"
        "animation popin 80%, initialclass:^(clipse)$"

        # Float Rules
        "float, title:^(viewnior)$"
        "float, title:^(nwg-look)$"
        "float, title:^(Rofi)$"
        "float, title:^(thunar)$"
        "float, title:^(org.gnome.Calculator)$"
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
        "float, title:^(*.exe)$"
        "float, title:^(feh)$"
        "float, title:^(Color Picker)$"
        "float, class:^(kitty-maple1)$, title:^(maple)$"
        "float, class:^(firefox)$, title:^(Picture-in-Picture)$"
        "float, class:^(firefox)$, title:^(Firefox — Sharing Indicator)$"
        "float, class:^(firefox)$, title:^(Extension.*"
        "float, class:^(brave)$, title:^(Save File)$"
        "float, class:^(brave)$, title:^(Open File)$"
        "float, class:^(xdg-desktop-portal-gtk)$"
        "float, class:^(krita)$"
        "float, title:^(Picture in picture)$"
        "float, class:^(org.twosheds.iwgtk)$"
        "float, initialclass:^(org.telegram.desktop)$, title:(.*Mini App.*)"
        "float, initialclass:^(VirtualBox Manager)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(blueberry.py)$"
        "float, class:^(tflexcad.exe)$"
        "float, class:^(BasemarkGPU)$"
        "float, class:^(jamesdsp)$"
        "float, class:^(wlogout)$"
        "float, class:^(geeqie)$"
        "float, class:^(clipse)"

        "pin, title:^(Picture in picture)$"
        "tile, class:^(neovide)$"

        # Shimeji Rules
        "noborder, title:^(com-group_finity-mascot-Main)$"
        "noshadow, title:^(com-group_finity-mascot-Main)$"
        "nofocus,  title:^(com-group_finity-mascot-Main)$"
        "noblur,   title:^(com-group_finity-mascot-Main)$"
        "float,    title:^(com-group_finity-mascot-Main)$"

        # Smart Gaps Rules
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"

        # Topterm Rule
        "float, initialclass:^(topTerm)$"
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
        "GDK_SCALE, 2"
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
      ];
    };

    # Add startup commands and import bindings through extraConfig
    extraConfig = ''
      # Import keybindings from separate file
      source = /home/dmitry/configs/home/programs/wayland/hyprland/binds.conf

      # Execute startup scripts
      exec-once = bash ${launch_misc}/bin/launch_misc 2>${config.xdg.dataHome}/launch_misc.log
      exec-once = hyprctl setcursor Bibata-Modern-Classic 24
    '';
  };
}
