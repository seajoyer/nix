{ pkgs, lib }:

pkgs.stdenv.mkDerivation {
  pname = "gols";
  version = "0.1"; # Replace with the actual version

  src = pkgs.fetchFromGitHub {
    owner = "Tigermen0710";
    repo = "gols";
    rev = "e8bee7f"; # You might want to specify a specific commit or tag
    sha256 =
      "sha256-bZ95uoa0dqkf4XDmFpylEvQ083ue9Ox69QU+VhyXRtU="; # Replace with the actual sha256
  };

  buildInputs = [ pkgs.gccgo pkgs.bash ];

  installPhase = ''
    mkdir -p $out/bin
    gccgo gols.go -o gols
    chmod +x gols # Ensure the binary is executable
    cp gols $out/bin/
    cp gols.sh $out/bin/gols
  '';

  meta = {
    description = "A Golang ls with nerd fonts icons";
    homepage = "https://github.com/Tigermen0710/gols";
    license = lib.licenses.wtfpl; # Replace with the actual license if different
    maintainers = with lib.maintainers; [ dasidiuk ];
  };
}
