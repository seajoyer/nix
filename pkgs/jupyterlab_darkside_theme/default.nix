{ lib, python3Packages, fetchPypi }:

with python3Packages;

buildPythonPackage rec {
  pname = "jupyterlab_darkside_theme";
  version = "0.1.2";

  propagatedBuildInputs = [ notebook hatchling hatch-nodejs-version ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZjIjkZeryl6KxtG1jJ3TwD3Laf/Dmwu2s6HbfX+nMjY=";
  };

  meta = with lib; {
    description = "A dark theme for JupyterLab.";
    homepage = "https://github.com/dunovank/jupyterlab_darkside_theme";
    license = licenses.bsd3;
  };
}
