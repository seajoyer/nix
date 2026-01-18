{ pkgs, ... }:

{
  home.packages = [ pkgs.pyprland ];

  xdg.configFile."hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [ "scratchpads" ]

    [scratchpads.topTerm]
    command = "kitty --class topTerm"
    allow_special_workspaces = true
    lazy = false
    class = "topTerm"
    animation = "fromTop"
    size = "50% 35%"
    max_size = "1920px 100%"
    position = "512px 20px"
    unfocus = "hide"
    # smart_focus = false

    # [scratchpads.calc]
    # command = "kitty --class calc bc -q -l"
    # # allow_special_workspaces = true
    # class = "calc"
    # lazy = false
    # animation = "fromRight"
    # position = "1568px 20px"
    # offset = 700
    # size = "462px 286px"
    # hysteresis = 10
    # hide_delay = 0.3
    # unfocus = "hide"
  '';
}
