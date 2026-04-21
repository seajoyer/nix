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
    stateVersion  = "24.05"; # never change
  };

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  my.editors.emacs.enable = true;
  my.editors.vim.enable   = true;

  my.desktop.bar = "noctalia";

  my.apps = {
    browsers.enable = true;
    gaming.enable   = true;
    media.enable    = true;
    misc.enable     = true;
    office.enable   = true;
    art.enable      = false;
  };

  sops = {
    age.keyFile       = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile   = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };
}
