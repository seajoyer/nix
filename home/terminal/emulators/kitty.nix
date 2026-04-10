{ pkgs, lib, ... }:

{
  # Configure Kitty to include a dynamic theme file
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    font = {
      name = "JetBrainsMono Nerd Font Propo";
      size = 14;
    };
    settings = {
      copy_on_select = true;
      strip_trailing_spaces = "smart";
      enable_audio_bell = false;
      background_opacity = "0.85";
      dynamic_background_opacity = true;
      remember_window_size = false;
      initial_window_width = 1200;
      initial_window_height = 742;
      window_padding_width = "8 10 8";
      confirm_os_window_close = 2;
      close_on_child_death = true;
      allow_remote_control = true;
      cursor_shape = "beam";
      background = "#000000";
    };
    keybindings = {
      "kitty_mod+a>m" = "set_background_opacity +0.1";
      "kitty_mod+a>l" = "set_background_opacity -0.1";
      "kitty_mod+a>1" = "set_background_opacity 1";
      "kitty_mod+a>0" = "set_background_opacity 0";
      "kitty_mod+a>d" = "set_background_opacity default";
    };

    extraConfig = ''
      include themes/noctalia.conf
      # include current-theme.conf
      # include dank-tabs.conf
      # include dank-theme.conf
    '';
  };

  # Create the theme converter script
  home.packages = [
    (pkgs.writeShellScriptBin "update-kitty-theme" ''
      #!/usr/bin/env bash
      sequences_file="$HOME/.local/state/caelestia/sequences.txt"
      kitty_theme="$HOME/.config/kitty/current-theme.conf"

      if [[ -f "$sequences_file" ]]; then
        sequences=$(cat "$sequences_file")

        # Parse ANSI sequences and convert to Kitty format
        {
          echo "# Auto-generated theme from caelestia"

          # Extract colors from ANSI sequences
          # Format: \x1b]11;rgb:RR/GG/BB\x1b\\ (background)
          bg=$(echo "$sequences" | grep -o '11;rgb:[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]' | sed 's/11;rgb:\(..\)\/\(..\)\/\(..\)/#\1\2\3/')
          fg=$(echo "$sequences" | grep -o '10;rgb:[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]' | sed 's/10;rgb:\(..\)\/\(..\)\/\(..\)/#\1\2\3/')
          cursor=$(echo "$sequences" | grep -o '12;rgb:[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]' | sed 's/12;rgb:\(..\)\/\(..\)\/\(..\)/#\1\2\3/')
          selection=$(echo "$sequences" | grep -o '17;rgb:[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]' | sed 's/17;rgb:\(..\)\/\(..\)\/\(..\)/#\1\2\3/')

          [[ -n "$bg" ]] && echo "background $bg"
          [[ -n "$fg" ]] && echo "foreground $fg"
          [[ -n "$cursor" ]] && echo "cursor $cursor"
          [[ -n "$selection" ]] && echo "selection_background $selection"

          # Extract terminal colors (0-15)
          for i in {0..15}; do
            color=$(echo "$sequences" | grep -o "4;$i;rgb:[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]" | sed "s/4;$i;rgb:\(..\)\/\(..\)\/\(..\)/#\1\2\3/")
            [[ -n "$color" ]] && echo "color$i $color"
          done

        } > "$kitty_theme"

        # Apply sequences to all active terminal sessions
        pts_path="/dev/pts"
        if [[ -d "$pts_path" ]]; then
          for pt in "$pts_path"/*; do
            if [[ -c "$pt" && $(basename "$pt") =~ ^[0-9]+$ ]]; then
              echo -n "$sequences" > "$pt" 2>/dev/null || true
            fi
          done
        fi

        echo "Kitty theme updated: $kitty_theme"
      fi
    '')
  ];

  # Auto-update theme file when caelestia changes sequences
  systemd.user.services.kitty-theme-updater = {
    Unit = {
      Description = "Update kitty theme file from caelestia";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p $HOME/.local/state/caelestia && ${pkgs.inotify-tools}/bin/inotifywait -m -e modify,create $HOME/.local/state/caelestia/sequences.txt --format \"%f\" | while read file; do update-kitty-theme; done'";
      Restart = "always";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };

  # Create initial theme file at activation
  home.activation.createKittyTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/.config/kitty
    if [[ ! -f $HOME/.config/kitty/current-theme.conf ]]; then
      echo "# Caelestia theme will be auto-generated here" > $HOME/.config/kitty/current-theme.conf
    fi
  '';
}
