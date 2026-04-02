{ lib, stdenvNoCC, appimageTools, fetchurl }:

let
  pname = "fileuni-gui";
  version = "0.1.2";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.2/FileUni-gui-x86_64-linux-gnu.AppImage"; hash = "sha256-2ciNSIYAihXp3/6t6iZUeVWZIdPHm1o6+d5H2ZNCfPw="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.2/FileUni-gui-aarch64-linux-gnu.AppImage"; hash = "sha256-lLWdmXLX68HyKv5EFPbE7QmLixl8fAtK9TxjFuZvC+0="; };
  };
  source = sources.${stdenvNoCC.hostPlatform.system}
    or (throw "Unsupported system for FileUni GUI: ${stdenvNoCC.hostPlatform.system}");
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = source.url;
    hash = source.hash;
  };

  meta = with lib; {
    description = "FileUni GUI";
    homepage = "https://fileuni.com";
    mainProgram = "fileuni-gui";
    platforms = builtins.attrNames sources;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
