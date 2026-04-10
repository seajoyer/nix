{
  ...
}:

{
  imports = [
    ../../../home/editors
    ../../../home/programs
    ../../../home/services
    ../../../home/terminal
    ../../../home/fonts

    ../../../home/services/system/udiskie.nix
    ../../../home/services/system/polkit-agent.nix
  ];

  config = {
    home = {
      username = "dmitry";
      homeDirectory = "/home/dmitry";
      stateVersion = "24.05";
    };

    nixpkgs.config.allowUnfree = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
