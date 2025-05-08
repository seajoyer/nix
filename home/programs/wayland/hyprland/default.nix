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

    nix run /home/dmitry/configs/home/services/marble/shell/#astal -- -t launcher
  '';

  astal-powermenu = pkgs.writeShellScriptBin "astal-powermenu" ''
    #!/usr/bin/env bash

    # Export necessary environment variables that might be missing in Hyprland context
    export PATH=$PATH:${pkgs.nix}/bin

    nix run /home/dmitry/configs/home/services/marble/shell/#astal -- -t powermenu
  '';

  astal-screenrecord = pkgs.writeShellScriptBin "astal-screenrecord" ''
    #!/usr/bin/env bash

    # Export necessary environment variables that might be missing in Hyprland context
    export PATH=$PATH:${pkgs.nix}/bin

    nix run /home/dmitry/configs/home/services/marble/shell/#screenrecord
  '';

in {
  imports = [ ./plugins ];

  home.packages = with pkgs; [
    bibata-hyprcursor
    astal-launcher
    astal-powermenu
    astal-screenrecord
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
      debug = {
        disable_logs = false;
      };

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
      cursor = {
        inactive_timeout = 10;
      };

      # XWAYLAND SETTINGS
      xwayland = {
        force_zero_scaling = true;
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
          brightness = 1;
          contrast = 1.5;
          passes = 5;
          size = 3;
          xray = 1;
        };

        shadow = {
          enabled = 1;
          ignore_window = 1;
          render_power = 4;
          color_inactive = "0xaa2a2a2a";
          color = "0xee1a1a1a";
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
        "special:1, on-created-empty:[float] telegram-desktop"
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

        overview = {
          overrideAnimSpeed = 2.5;
          exitOnSwitch = 1;
          panelHeight = 200;
          workspaceActiveBorder = "0xbb8ab4f8";
        };

        hyprbars = {
          bar_height = 18;
          bar_text_size = 14;
          bar_text_font = "Inter Nerd Font Propo";
          "col.text" = "rgba(E4E4E4AA)";
          bar_part_of_window = true;
          bar_precedence_over_border = false;
          bar_buttons_alignment = "left";
          bar_padding = 18;
          bar_button_padding = 10;
          "hyprbars-button" = [
            "rgb(ff7f7f), 10, , hyprctl dispatch killactive"
            "rgb(e4b53f), 10, , hyprctl dispatch fullscreen 1"
            "rgb(a0d26f), 10, , hyprctl dispatch togglefloating"
          ];
        };
      };

      # APPLICATION DEFINITIONS
      "$clieditor" = "emacsclient --create-frame --tty";
      "$editor" = "emacsclient --create-frame";
      "$systemMonitor" = "btop";
      "$browser" = "firefox";
      "$explorer" = "kitty vifm";
      "$terminal" = "kitty";

      # BINDINGS
      bind = [
        # Clipse
        "SUPER, V, exec, kitty -o background_opacity=0.7 -o font_size=13 --class clipse -e zsh -c 'clipse'"

        # Scratchpads
        "SUPER, RETURN, exec, pypr toggle topTerm"

        # Screen Capture
        ", Print, exec, grim -g \"$(slurp)\" - | tee /tmp/screenshot.png | wl-copy && notify-send -i /tmp/screenshot.png \"Screenshot\" \"Area screenshot copied to clipboard\""
        "SHIFT, Print, exec, grim - | tee /tmp/screenshot.png | wl-copy && notify-send -i /tmp/screenshot.png \"Screenshot\" \"Full screen screenshot copied to clipboard\""
        "CTRL, Print, exec, wl-ocr"

        # Application Launchers
        "SUPER, XF86AudioMute, exec, $terminal --single-instance"
        "SUPERSHIFT, E, exec, kitty $clieditor"
        "SUPERSHIFT, S, exec, kitty $systemMonitor"
        "SUPER, Z, exec, hyprlock"
        "SUPER, W, exec, $browser"
        "SUPER, C, exec, $explorer"
        "SUPER, E, exec, $editor"
        "SUPER, backspace, exec, wlogout"
        "SUPER, I, exec, killall hyprsunset"
        "SUPER, N, layoutmsg, orientationnext"
        "SUPER, R, exec, astal-launcher"
        "SUPER, Escape, exec, astal-powermenu"
        "ALT, Print, exec, astal-screenrecord"

        # Hyprland Controls
        "SUPERCTRL, B, exec, hyprctl keyword general:gaps_in 5 && hyprctl keyword general:gaps_out 8 && hyprctl keyword decoration:drop_shadow 1 && hyprctl keyword decoration:rounding 15 && hyprctl keyword decoration:blur:enabled 1 && hyprctl keyword decoration:drop_shadow 1 && hyprctl keyword animations:enabled 1"
        "SUPERALT, B, exec, hyprctl keyword general:gaps_in 0 && hyprctl keyword general:gaps_out 0 && hyprctl keyword decoration:drop_shadow 0 && hyprctl keyword decoration:rounding 0 && hyprctl keyword decoration:blur:enabled 0 && hyprctl keyword decoration:drop_shadow 0 && hyprctl keyword animations:enabled 0"

        "SUPER, Q, killactive"
        "SUPER, M, exec, hyprctl keyword general:layout master"
        "SUPER, D, exec, hyprctl keyword general:layout dwindle"
        "SUPER, RETURN, layoutmsg, swapwithmaster"
        "SUPER, Tab, cyclenext,"
        "SUPER, Tab, bringactivetotop,"
        "SUPERSHIFT, Tab, cyclenext, prev"
        "SUPERSHIFT, Tab, bringactivetotop,"

        "SUPER, P, pseudo"
        "SUPERSHIFT, P, workspaceopt, allpseudo"
        "SUPER, Space, togglefloating, active"
        "SUPERSHIFT, Space, workspaceopt, allfloat"

        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"

        "SUPER, F, fullscreen, 1"
        "SUPERSHIFT, F, fullscreen, 0"
        "SUPER, S, togglesplit"

        "SUPERSHIFT, Q, exec, hyprctl kill"
        "CTRLALT, Delete, exit"

        # Laptop Controls
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl stop"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86Favorites, togglespecialworkspace, 1"
        "ALTCTRL, TAB, togglespecialworkspace, 2"

        # Workspace Management
        "SUPERSHIFT, 1, movetoworkspacesilent, 1"
        "SUPERSHIFT, 2, movetoworkspacesilent, 2"
        "SUPERSHIFT, 3, movetoworkspacesilent, 3"
        "SUPERSHIFT, 4, movetoworkspacesilent, 4"
        "SUPERSHIFT, 5, movetoworkspacesilent, 5"
        "SUPERSHIFT, 6, movetoworkspacesilent, 6"
        "SUPERSHIFT, 7, movetoworkspacesilent, 7"
        "SUPERSHIFT, 8, movetoworkspacesilent, 8"
        "SUPERSHIFT, 9, movetoworkspacesilent, 9"

        "SUPERSHIFT, XF86AudioMute, movetoworkspace, special:1"
        "SUPERSHIFT, XF86AudioLowerVolume, movetoworkspace, special:2"
        "SUPERALT, 1, movetoworkspace, 1"
        "SUPERALT, 2, movetoworkspace, 2"
        "SUPERALT, 3, movetoworkspace, 3"
        "SUPERALT, 4, movetoworkspace, 4"
        "SUPERALT, 5, movetoworkspace, 5"
        "SUPERALT, 6, movetoworkspace, 6"
        "SUPERALT, 7, movetoworkspace, 7"
        "SUPERALT, 8, movetoworkspace, 8"
        "SUPERALT, 9, movetoworkspace, 9"

        "SUPER, 0, togglespecialworkspace, 1"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"

        # Window Movement
        "SUPERSHIFT, h, swapwindow, l"
        "SUPERSHIFT, l, swapwindow, r"
        "SUPERSHIFT, k, swapwindow, u"
        "SUPERSHIFT, j, swapwindow, d"

        # Focus Controls
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"

        # Window Grouping
        "SUPER, g, togglegroup"
        "SUPERALT, h, movewindoworgroup, l"
        "SUPERALT, j, movewindoworgroup, d"
        "SUPERALT, k, movewindoworgroup, u"
        "SUPERALT, l, movewindoworgroup, r"

        # Special Workspace Controls
        "SUPER, backslash, togglespecialworkspace, minimized"
      ];

      binde = [
        # Window Resizing
        "SUPERCTRL, k, resizeactive, 0 -20"
        "SUPERCTRL, j, resizeactive, 0 20"
        "SUPERCTRL, l, resizeactive, 20 0"
        "SUPERCTRL, h, resizeactive, -20 0"
        "SUPERALT, k, moveactive, 0 -20"
        "SUPERALT, j, moveactive, 0 20"
        "SUPERALT, l, moveactive, 20 0"
        "SUPERALT, h, moveactive, -20 0"
        "ALTCTRL, h, splitratio, -0.04"
        "ALTCTRL, l, splitratio, +0.04"
        "SUPER, right, workspace, e+1"
        "SUPER, left, workspace, e-1"
        "SUPER, F, fullscreen, 1"
        "SUPERSHIFT, F, fullscreen, 0"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "CTRL, Tab, changegroupactive, f"
        "CTRLSHIFT, Tab, changegroupactive, b"
      ];

      bindm = [
        # Mouse Controls
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:272, movewindow"
      ];

      bindl = [
        # Media Controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl stop"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      # ENVIRONMENT VARIABLES
      env = [
        "XCURSOR_THEME, GoogleDot-Black"
        "XCURSOR_SIZE, 24"
        "HYPRCURSOR_THEME, Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE, 24"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "QT_QPA_PLATFORM, wayland;xcb"
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

    # Add startup commands through extraConfig to ensure they run properly
    extraConfig = ''
      # Execute startup scripts
      exec-once = bash ${launch_misc}/bin/launch_misc 2>${config.xdg.dataHome}/launch_misc.log
      exec-once = hyprctl setcursor Bibata-Modern-Classic 24
    '';
  };
}
