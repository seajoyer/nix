{ lib, pkgs, config, ... }:

with config.my; {
    home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = adjust 24;
        gtk.enable = true;
        x11.enable = true;
    };

    gtk = {
        enable = true;
        cursorTheme = {
            name = "Bibata-Modern-Classic";
            package = pkgs.bibata-cursors;
        };
        theme = {
            package = pkgs.adw-gtk3;
            name = "adw-gtk3-dark";
        };
        iconTheme = {
            package = pkgs.gnome.adwaita-icon-theme;
            name = "Adwaita";
        };
        font = {
            name = "Inter";
            size = adjust 12;
        };
    };
}
