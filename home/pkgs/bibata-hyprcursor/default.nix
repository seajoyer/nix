{ lib
, stdenvNoCC
, fetchurl
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-hyprcursor";
  version = "1.0";  # Update this version as needed

  src = fetchurl {
    url = "https://drive.usercontent.google.com/download?id=1HkJPuKNkf4zfVYbQ6IxHUl5KaDXgFest";
    name = "HyprBibataModernClassic.tar.gz";
    hash = "sha256-KDYoULjJC0Nhdx9Pz5Ezq+1F0tWwkVQIc5buy07hO98=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r $PWD $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "Bibata Cursor theme for Hyprland";
    homepage = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
