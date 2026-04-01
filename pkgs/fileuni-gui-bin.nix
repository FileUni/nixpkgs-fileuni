{ lib, stdenvNoCC, appimageTools, fetchurl }:

let
  pname = "fileuni-gui";
  version = "0.1.1";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1/FileUni-gui-x86_64-linux-gnu.AppImage"; hash = "sha256-9SpKZYw0xprleiFNvkZ5smoMp9fqVRQGagyY+phlIsc="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1/FileUni-gui-aarch64-linux-gnu.AppImage"; hash = "sha256-WFoNj7YEM3DOltd8DWZDy9J4fRi+Y8afcuKuUbsbPpQ="; };
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
