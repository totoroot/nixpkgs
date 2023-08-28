{ lib
, buildGoModule
, fetchFromGitHub
, graphviz
, makeBinaryWrapper
}:

buildGoModule rec {
  pname = "k8sviz";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "totoroot";
    repo = pname;
    rev = "customisable-icons-path";
    hash = "sha256-3SfpKQWmuAo6oaesQ2NwViH2XW2EgO4RnIXUEaHYTeI=";
  };
  vendorHash = "sha256-9pFq1OPh8RbdtEyttjr2GjiRHdRfiKVwtgk0WcG0K5o=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = let
    runtimeInputs = [ graphviz ];
  in ''
    runHook preInstall
    mkdir -p $out/share
    cp -r icons $out/share/
    cp -r $GOPATH/bin $out
    chmod +x $out/bin/k8sviz
    wrapProgram $out/bin/k8sviz --append-flags "--icons ../share/icons" --prefix PATH : ${lib.makeBinPath runtimeInputs}
    runHook postInstall
  '';

  # e2e tests need a proper KUBECONFIG file
  checkPhase = ''
    go test $(go list ./... | grep -vE '(e2e)')
  '';

  meta = with lib; {
    description = "Generate Kubernetes architecture diagrams from the actual state in a namespace ";
    homepage = "https://github.com/totoroot/k8sviz";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ totoroot ];
  };
}
