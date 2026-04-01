{ lib, stdenvNoCC, appimageTools, fetchurl }:

let
  pname = "fileuni-gui";
  version = "0.1.1-alpha.1.20260401184702";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1-alpha.1_20260401184702/FileUni-gui-x86_64-linux-gnu.AppImage"; hash = "sha256-n2GxqbD+87IKsBTVzyTDR0OGjFXF8hU5LK+bwbIAocw="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1-alpha.1_20260401184702/FileUni-gui-aarch64-linux-gnu.AppImage"; hash = "sha256-nV4+QuHl+Ugb3b8pNaomdoQB7BBle/qiRn5HlTUrqDk="; };
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
