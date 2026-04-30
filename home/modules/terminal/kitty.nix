{ pkgs, lib, config, ... }:

lib.mkIf config.my.terminal.kitty.enable {
  programs.kitty = {
    enable  = true;
    package = pkgs.kitty;

    font = {
      name = "JetBrainsMono Nerd Font Propo";
      size = 14;
    };

    settings = {
      copy_on_select          = true;
      strip_trailing_spaces   = "smart";
      enable_audio_bell       = false;
      background_opacity      = "0.80";
      dynamic_background_opacity = true;
      remember_window_size    = false;
      initial_window_width    = 1200;
      initial_window_height   = 742;
      window_padding_width    = "8 10 8";
      confirm_os_window_close = 2;
      close_on_child_death    = true;
      allow_remote_control    = true;
      cursor_shape            = "beam";
      background              = "#000000";
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
    '';
  };

  # Watch for caelestia/noctalia theme changes and apply them to running terminals
  home.packages = [
    (pkgs.writeShellScriptBin "update-kitty-theme" ''
      sequences_file="$HOME/.local/state/caelestia/sequences.txt"
      kitty_theme="$HOME/.config/kitty/current-theme.conf"

      [ -f "$sequences_file" ] || exit 0
      sequences=$(cat "$sequences_file")

      {
        echo "# Auto-generated theme from caelestia/noctalia"

        extract() {
          echo "$sequences" \
            | grep -o "$1;rgb:[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]/[0-9a-f][0-9a-f]" \
            | sed "s/$1;rgb:\(..\)\/\(..\)\/\(..\)/#\1\2\3/"
        }

        bg=$(extract 11);  [ -n "$bg" ]     && echo "background $bg"
        fg=$(extract 10);  [ -n "$fg" ]     && echo "foreground $fg"
        cur=$(extract 12); [ -n "$cur" ]    && echo "cursor $cur"
        sel=$(extract 17); [ -n "$sel" ]    && echo "selection_background $sel"

        for i in {0..15}; do
          c=$(extract "4;$i"); [ -n "$c" ] && echo "color$i $c"
        done
      } > "$kitty_theme"

      # Propagate to every running pseudo-terminal
      for pt in /dev/pts/[0-9]*; do
        [ -c "$pt" ] && echo -n "$sequences" > "$pt" 2>/dev/null || true
      done
    '')
  ];

  systemd.user.services.kitty-theme-updater = {
    Unit.Description = "Re-apply kitty theme whenever sequences file changes";
    Service = {
      Type       = "simple";
      ExecStart  = "${pkgs.bash}/bin/bash -c '${pkgs.inotify-tools}/bin/inotifywait -m -e modify,create $HOME/.local/state/caelestia/sequences.txt --format \"%f\" | while read f; do update-kitty-theme; done'";
      Restart    = "always";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.activation.createKittyTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.config/kitty
    [ -f $HOME/.config/kitty/current-theme.conf ] \
      || echo "# Theme placeholder — populated by update-kitty-theme" \
           > $HOME/.config/kitty/current-theme.conf
  '';
}
