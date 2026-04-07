{ lib, stdenvNoCC, appimageTools, fetchurl }:

let
  pname = "fileuni-gui";
  version = "0.1.6-alpha.1.20260407083440";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.6-alpha.1_20260407083440/FileUni-gui-x86_64-linux-gnu.AppImage"; hash = "sha256-IBSfnukKsMrZ9+1sV/PvS/pDo+jjIp8mXXXrGdlSD7Y="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.6-alpha.1_20260407083440/FileUni-gui-aarch64-linux-gnu.AppImage"; hash = "sha256-sKeGd9VAaKnZMjvA+jU3i88pSBv6G+TWGP5O2+nDQF8="; };
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
