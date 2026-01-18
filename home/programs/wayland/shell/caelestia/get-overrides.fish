touch ~/.config/hypr/overrides.conf

set -l src /home/dmitry/configs/home/programs/wayland/shell
set -q XDG_CONFIG_HOME && set -l config $XDG_CONFIG_HOME/hypr || set -l config $HOME/.config/hypr

test -f $config/hypr.json && set -l style (jq -r '.hyprland.style' $config/hypr.json)
test -f "$src/templates/hyprland/$style.conf" || set -l style aesthetic

set -l template $src/templates/hyprland/$style.conf
set -l dest ~/.config/hypr/overrides.conf

if ! diff -qN $template $dest > /dev/null
    cp $template $dest
    hyprctl reload
end
