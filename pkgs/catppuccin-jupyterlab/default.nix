{ lib, python3Packages }:

with python3Packages;

buildPythonPackage rec {
  pname = "catppuccin_jupyterlab";
  version = "0.2.3";

  propagatedBuildInputs = [ jupyterlab ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SbvN7ftUszFXxjlkruWq4t7FfPcg88PMetXluiVo1yA=";
  };

  meta = with lib; {
    description = "📊 Soothing pastel theme for JupyterLab.";
    homepage = "https://github.com/catppuccin/jupyterlab";
    license = licenses.mit;
  };
}
