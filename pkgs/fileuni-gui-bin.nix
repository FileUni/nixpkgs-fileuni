{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni-gui";
  version = "0.1.7-alpha.3.20260412035005";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.7-alpha.3_20260412035005/FileUni-gui-x86_64-linux-gnu.zip"; hash = "sha256-PynGrb93FnJx4/N88GCe6JC80le/FxKcI/O+CIfTHF4="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.7-alpha.3_20260412035005/FileUni-gui-aarch64-linux-gnu.zip"; hash = "sha256-OhMVG6Lfh21Ui6D+TsmsBtXLxb776JA0otBE6BdKwCY="; };
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
