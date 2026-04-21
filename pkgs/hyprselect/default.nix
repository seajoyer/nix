{ lib, fetchFromGitHub, hyprlandPlugins, ... }:

hyprlandPlugins.mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprselect";
  version = "unstable-2025-12-06";
  src = fetchFromGitHub {
    owner = "jmanc3";
    repo = "hyprselect";
    rev = "d20dd59ca60e0fc4ffacc2dd9e7024e962619517";
    hash = "sha256-prMa5aqXXHfQBqDNRWb9D1tpkYKpaJ84skhOv/Tpz04=";
  };

  installPhase = ''
    runHook preInstall
    install -D hyprselect.so $out/lib/libhyprselect.so
    runHook postInstall
  '';

  meta = {
    description = "A plugin that adds a desktop selection box to Hyprland";
    homepage = "https://github.com/jmanc3/hyprselect";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.linux;
  };
})
