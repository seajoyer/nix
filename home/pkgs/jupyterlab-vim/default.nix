{ lib, python3Packages, ... }:

with python3Packages;

buildPythonPackage rec {
  pname = "jupyterlab_vim";
  version = "4.1.3";

  # propagatedBuildInputs = [ notebook matplotlib lesscpy ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-V+GgpO3dIzTo16fA34D1CXt49UgP+oQwfy5QjfmLaHg=";
  };

  meta = with lib; {
    description = "Code cell vim bindings";
    homepage = "https://github.com/jupyterlab-contrib/jupyterlab-vim";
    license = licenses.mit;
  };
}
