{ lib
, buildGoModule
, fetchFromGitHub
, graphviz
}:

buildGoModule rec {
  pname = "k8sviz";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "mkimuram";
    repo = pname;
    rev = "${version}";
    hash = "sha256-UljSuaMKo3W49NfhG+bXrSZ7y/QocRT0rjVQrAUXZmg=";
  };
  vendorHash = "sha256-9pFq1OPh8RbdtEyttjr2GjiRHdRfiKVwtgk0WcG0K5o=";

  ldflags = [
    "-s"
    "-w"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r icons $out/bin
    runHook postInstall
  '';

  # e2e tests need a proper KUBECONFIG file
  checkPhase = ''
    go test $(go list ./... | grep -vE '(e2e)')
  '';

  meta = with lib; {
    description = "Generate Kubernetes architecture diagrams from the actual state in a namespace ";
    homepage = "https://github.com/mkimuram/k8sviz";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ totoroot ];
  };
}
