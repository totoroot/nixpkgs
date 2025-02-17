{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scrutiny";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "Analogj";
    repo = "scrutiny";
    rev = "v${version}";
    hash = "sha256-UYKi+WTsasUaE6irzMAHr66k7wXyec8FXc8AWjEk0qs=";
  };

  # subPackages = [ "." ];

  vendorHash = "sha256-SiQw6pq0Fyy8Ia39S/Vgp9Mlfog2drtVn43g+GXiQuI=";

  # preCheck = ''
  #   buildFlagsArray+="-short"
  # '';

  checkPhase = ''
  '';

  meta = with lib; {
    description = "Hard Drive S.M.A.R.T Monitoring, Historical Trends & Real World Failure Thresholds";
    homepage = "https://github.com/AnalogJ/scrutiny";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
  };
}
