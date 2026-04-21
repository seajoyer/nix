{ pkgs, lib }:

pkgs.stdenv.mkDerivation {
  pname = "gols";
  version = "0.1";

  src = pkgs.fetchFromGitHub {
    owner = "Tigermen0710";
    repo = "gols";
    rev = "e8bee7f";
    sha256 = "sha256-bZ95uoa0dqkf4XDmFpylEvQ083ue9Ox69QU+VhyXRtU=";
  };

  buildInputs = [
    pkgs.gccgo
    pkgs.bash
  ];

  installPhase = ''
    mkdir -p $out/bin
    gccgo gols.go -o gols
    chmod +x gols
    cp gols     $out/bin/
    cp gols.sh  $out/bin/gols
  '';

  meta = {
    description = "ls with Nerd Font icons (Go)";
    homepage = "https://github.com/Tigermen0710/gols";
    license = lib.licenses.wtfpl;
  };
}
