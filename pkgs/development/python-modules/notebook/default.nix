{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  hatch-jupyter-builder,
  hatchling,
  jupyter-server,
  jupyterlab,
  jupyterlab-server,
  notebook-shim,
  tornado,
  pytest-jupyter,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "notebook";
  version = "7.3.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cF6DoXhfRbODvz7hPLdmgLktJPVvsMfSE2/h2FDNPKg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "timeout = 300" ""
  '';

  build-system = [
    hatch-jupyter-builder
    hatchling
    jupyterlab
  ];

  dependencies = [
    jupyter-server
    jupyterlab
    jupyterlab-server
    notebook-shim
    tornado
  ];

  nativeCheckInputs = [
    pytest-jupyter
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  env = {
    JUPYTER_PLATFORM_DIRS = 1;
  };

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/jupyter/notebook/blob/v${version}/CHANGELOG.md";
    description = "Web-based notebook environment for interactive computing";
    homepage = "https://github.com/jupyter/notebook";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
    mainProgram = "jupyter-notebook";
  };
}
