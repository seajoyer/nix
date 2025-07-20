{ config, lib, pkgs, inputs, ... }:

{
  home.packages = [ inputs.pyprland.packages."x86_64-linux".pyprland ];

  xdg.configFile."hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [ "scratchpads" ]

    [scratchpads.topTerm]
    command = "kitty --class topTerm"
    # excludes = ["files"]
    # allow_special_workspaces = true
    lazy = false
    class = "topTerm"
    animation = "fromTop"
    size = "50% 35%"
    position = "512px 20px"
    # margin = 56
    offset = 700 #504
    hysteresis = 0.5
    hide_delay = 0.3
    unfocus = "hide"

    [scratchpads.calc]
    command = "kitty --class calc bc -q -l"
    # allow_special_workspaces = true
    class = "calc"
    lazy = false
    animation = "fromRight"
    position = "1568px 20px"
    offset = 700
    size = "462px 286px"
    hysteresis = 10
    hide_delay = 0.3
    unfocus = "hide"
  '';
}
