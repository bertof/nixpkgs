{ lib
, tcl
, tcllib
, tk
, fetchFromGitHub
, tclx
}:

let
  tclLibraries = [ tcl tcllib tclx tk ];
  version = "2.3.0";
in
tcl.mkTclDerivation {
  pname = "imunes";
  inherit version;

  src = fetchFromGitHub {
    owner = "imunes";
    repo = "imunes";
    rev = "v${version}";
    hash = "sha256-Qf5u4oHnsJLGpDPRGSYbxDICL8MWiajxFb5/FADLfqc=";
  };

  propagatedBuildInputs = tclLibraries;

  makeFlags = [ "PREFIX=$(out)" "DESTDIR=" ];

  postInstall = ''
    wrapProgram $out/bin/imunes \
      --prefix TCLLIBPATH : "${lib.makeLibraryPath tclLibraries}" \
      --prefix PATH : "${lib.makeBinPath [ tcl ]}"
  '';

  meta = {
    homepage = "https://imunes.net";
    description = "Integrated Multiprotocol Network Emulator/Simulator";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bertof ];
    platforms = lib.platforms.linux;
  };
}
