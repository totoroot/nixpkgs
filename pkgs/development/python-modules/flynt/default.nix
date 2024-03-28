{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, astor
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flynt";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ikamensh";
    repo = "flynt";
    rev = version;
    hash = "sha256-UHY4UDBHcP3ARikktIehSUD3Dx8A0xpOnfKWWrLCsOY=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [ astor ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Tool to automatically convert old string literal formatting to f-strings in Python code";
    longDescription = ''
      flynt is a command line tool to automatically convert a project's Python code from old "%-formatted" and .format(...) strings into Python 3.6+'s "f-strings".
    '';
    mainProgram = "flynt";
    homepage = "https://github.com/ikamensh/flynt";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud totoroot ];
  };
}
