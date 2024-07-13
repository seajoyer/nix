{ config, ... }:

{
    xdg = {
        enable = true;
        userDirs.enable = true;

        mimeApps.defaultApplications = {
            "application/pdf" = [ "zathura.desktop" ];
        };

        configFile = with config.xdg; {
            "bat/config".text = ''
              --theme="Nord"
              --italic-text=always
              --map-syntax='.ignore:Git Ignore'
            '';
        };
    };
}
