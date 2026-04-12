{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni-gui";
  version = "0.1.8-alpha.1.20260412224510";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.1_20260412224510/FileUni-gui-x86_64-linux-gnu.zip"; hash = "sha256-nokofNfu6awO+F+G4K6VzvOzZ1TJ/hJhA6ZxDU2nFv0="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.1_20260412224510/FileUni-gui-aarch64-linux-gnu.zip"; hash = "sha256-3RXN9p7LLARa3MtxIG7B08y3uzxsRh87phqtxCdX8xg="; };
  };
  source = sources.${stdenvNoCC.hostPlatform.system}
    or (throw "Unsupported system for FileUni GUI: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = source.url;
    hash = source.hash;
  };

  nativeBuildInputs = [ unzip ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack
    mkdir -p source
    unzip -q "$src" -d source
    runHook postUnpack
  '';

  sourceRoot = "source";

  installPhase = ''
    runHook preInstall
    install -Dm755 "$sourceRoot/fileuni-gui" "$out/bin/fileuni-gui"
    runHook postInstall
  '';

  meta = with lib; {
    description = "FileUni GUI";
    homepage = "https://fileuni.com";
    mainProgram = "fileuni-gui";
    platforms = builtins.attrNames sources;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
