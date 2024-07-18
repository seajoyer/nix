{ config, lib, pkgs, inputs, ... }:

{
  home.packages = [ inputs.pyprland.packages."x86_64-linux".pyprland ];

  xdg.configFile."hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [ "scratchpads" ]

    [scratchpads.topTerm]
    command = "kitty --class topTerm"
    # excludes = ["files", "term2"]
    allow_special_workspaces = true
    lazy = true
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
    class = "calc"
    lazy = true
    animation = "fromRight"
    position = "1568px 20px"
    offset = 700
    size = "462px 286px"
    allow_special_workspaces = true
    hysteresis = 10
    hide_delay = 0.3
    unfocus = "hide"
  '';
}
