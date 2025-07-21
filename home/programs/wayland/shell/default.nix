{ config, pkgs, ... }:

{
  xdg.configFile."hypr/hypr.json".text = ''
    {
        "hyprland": {
            "style": "functional"
        }
    }
  '';

  xdg.configFile."quickshell/shell.qml".text = ''
    {
        "background": {
            "enabled": true
        },
        "bar": {
            "dragThreshold": 20,
            "persistent": true,
            "showOnHover": false,
            "workspaces": {
                "activeIndicator": true,
                "activeLabel": "󰮯 ",
                "activeTrail": false,
                "label": "  ",
                "occupiedBg": false,
                "occupiedLabel": "󰮯 ",
                "rounded": true,
                "showWindows": true,
                "shown": 5
            }
        },
        "border": {
            "rounding": 25,
            "thickness": 0
        },
        "dashboard": {
            "mediaUpdateInterval": 500,
            "visualiserBars": 45
        },
        "launcher": {
            "actionPrefix": ">",
            "dragThreshold": 50,
            "enableDangerousActions": false,
            "maxShown": 8,
            "maxWallpapers": 9,
            "useFuzzy": {
                "apps": false,
                "actions": false,
                "schemes": false,
                "variants": false,
                "wallpapers": false
            }
        },
        "lock": {
            "maxNotifs": 5
        },
        "notifs": {
            "actionOnClick": false,
            "clearThreshold": 0.3,
            "defaultExpireTimeout": 5000,
            "expandThreshold": 20,
            "expire": false
        },
        "osd": {
            "hideDelay": 2000
        },
        "paths": {
            "mediaGif": "root:/assets/bongocat.gif",
            "sessionGif": "root:/assets/kurukuru.gif",
            "wallpaperDir": "~/Pictures/Wallpapers"
        },
        "services": {
          "weatherLocation": "10,10",
          "useFahrenheit": false
        },
        "session": {
            "dragThreshold": 30
        }
    }
  '';
}
