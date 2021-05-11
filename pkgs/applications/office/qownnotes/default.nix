{ mkDerivation, lib, stdenv, fetchurl
, qmake, qttools, qtbase, qtsvg, qtdeclarative, qtxmlpatterns, qtwebsockets
, qtx11extras, qtwayland, darwin }:

mkDerivation rec {
  pname = "qownnotes";
  version = "22.11.7";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    # Fetch the checksum of current version with curl:
    # curl https://download.tuxfamily.org/qownnotes/src/qownnotes-<version>.tar.xz.sha256
    sha256 = "2fbc20f17422bc44c35dd3e78feb710ca275ecb34c550b2a9c743939531f7878";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase qtsvg qtdeclarative qtxmlpatterns qtwebsockets qtx11extras ]
    ++ lib.optional stdenv.isLinux qtwayland
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa;

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv "$out/bin/QOwnNotes.app" $out/Applications

    # Fix 'Could not find the Qt platform plugin "cocoa" in ""' error
    wrapQtApp "$out/Applications/QOwnNotes.app/Contents/MacOS/QOwnNotes"

    ln -s "$out/Applications/QOwnNotes.app/Contents/MacOS/QOwnNotes" $out/bin/qownnotes
  '';

  meta = with lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration.";
    homepage = "https://www.qownnotes.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ totoroot ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
