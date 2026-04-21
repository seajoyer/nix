{ pkgs, lib, makeWrapper, ... }:

pkgs.stdenv.mkDerivation {
  pname = "ipman";
  version = "v0.1.0"; # Replace with the actual version

  src = pkgs.fetchFromGitHub {
    owner = "L3N76";
    repo = "ipman";
    rev = "d8fd874";
    sha256 = "sha256-uLaoGcXPb79h+BT7jSk6Ubu4X/SCpn1Q2kiAGlJ30AA=";
  };

  buildInputs = [ pkgs.bash makeWrapper ];

  installPhase = ''
    make PREFIX=$out DESTDIR=$out install
  '';

  meta = {
    description = "Ideapad Power Manager for Linux";
    homepage = "https://github.com/L3N76/ipman";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ seajoyer ];
  };
}
