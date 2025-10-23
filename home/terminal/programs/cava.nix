{ config, lib, pkgs, ... }:

{
  programs.cava = {
    enable = true;
    settings = {
      general = {
        bars = 20;
        framerate = 60;
      };
    };
  };
}
