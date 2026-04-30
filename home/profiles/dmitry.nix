{ config, ... }:

{
  imports = [
    ../modules/core
    ../modules/shell
    ../modules/terminal
    ../modules/editors
    ../modules/desktop
    ../modules/apps
    ../modules/services
  ];

  home = {
    username      = "dmitry";
    homeDirectory = "/home/dmitry";
    stateVersion  = "24.05";  # never change
  };

  # ── Editors ───────────────────────────────────────────────────────────
  my.editors.emacs.enable = true;
  my.editors.vim.enable   = true;

  # ── Core ──────────────────────────────────────────────────────────────
  my.core.xdg.enable     = true;
  my.core.fonts.enable   = true;
  my.core.theming.enable = true;

  # ── Shell ─────────────────────────────────────────────────────────────
  my.shell.zsh.enable   = true;
  my.shell.git.enable   = true;
  my.shell.ssh.enable   = true;
  my.shell.tools.enable = true;
  my.shell.vifm.enable  = true;

  # ── Terminal ──────────────────────────────────────────────────────────
  my.terminal.kitty.enable   = true;
  my.terminal.nushell.enable = true;

  # ── Desktop ───────────────────────────────────────────────────────────
  my.desktop.bar               = "noctalia";
  my.desktop.wayland.enable    = true;
  my.desktop.niri.enable       = true;
  my.desktop.hypridle.enable   = true;
  my.desktop.hyprlock.enable   = true;
  my.desktop.hyprsunset.enable = true;
  my.desktop.wlogout.enable    = true;
  my.desktop.vpn.enable        = true;
  my.desktop.vicinae.enable    = true;

  # ── Services ──────────────────────────────────────────────────────────
  my.services.fusuma.enable    = false;
  my.services.playerctl.enable = true;
  my.services.udiskie.enable   = true;
  my.services.polkit.enable    = true;

  # ── Apps ──────────────────────────────────────────────────────────────
  my.apps.browsers.enable = true;
  my.apps.gaming.enable   = true;
  my.apps.media.enable    = true;
  my.apps.misc.enable     = true;
  my.apps.office.enable   = true;
  my.apps.art.enable      = true;

  sops = {
    age.keyFile       = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile   = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };
}
