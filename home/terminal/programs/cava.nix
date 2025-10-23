{ config, lib, pkgs, ... }:

{
  cava = {
    enabled = true;
    general = {
      bars = 20;
      framerate = 60;
    };
  };
}
