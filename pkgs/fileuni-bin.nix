{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.7-alpha.3.20260412035005";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.7-alpha.3_20260412035005/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-FCQI59hNEWw6qB4WLJmuHalgsR7OgM+EU5zqUqn8Qsk="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.7-alpha.3_20260412035005/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-zY2tNFdp3dbERygAwVOuqwjN1RIy/2ML+MgNrJ8c3Tw="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.7-alpha.3_20260412035005/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-yJNIWsYaBnK/Gd6mEigyDIxCfcRTerWYO+RX1Ucw6Ew="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.7-alpha.3_20260412035005/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-MBoy85ljse7oOH2pijnmeNfoTZWWg+H7CjN6YXiPkQc="; };
  };
  source = sources.${stdenvNoCC.hostPlatform.system}
    or (throw "Unsupported system for FileUni: ${stdenvNoCC.hostPlatform.system}");
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
    install -Dm755 "$sourceRoot/fileuni" "$out/bin/fileuni"
    runHook postInstall
  '';

  meta = with lib; {
    description = "FileUni CLI";
    homepage = "https://fileuni.com";
    mainProgram = "fileuni";
    platforms = builtins.attrNames sources;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
