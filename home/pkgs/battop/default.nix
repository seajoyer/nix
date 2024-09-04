{ lib, fetchFromGitHub, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "battop";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "svartalf";
    repo = "rust-battop";
    rev = "v${version}";
    sha256 = "sha256-PHh1bL9ESc5PXbq4JoT+l7/UkMz/w+1ETTxckQeVo1w=";
  };

  cargoSha256 = "sha256-7wj34YVcoFhgGWlMtv1MROwx6d1FhDqkUeQJjohjcAI=";

  # cargoLock = {
  #   lockFile = ./Cargo.lock;
  # };

  meta = with lib; {
    description = "Interactive batteries viewer";
    homepage = "https://github.com/svartalf/rust-battop";
    # license = licenses.mit;
    maintainers = with maintainers; [ seajoyer ];
  };
}
