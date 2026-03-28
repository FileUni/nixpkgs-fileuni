{ lib, stdenvNoCC, appimageTools, fetchurl }:

let
  pname = "fileuni-gui";
  version = "1.0.0-alpha.1.20260329012348";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.1_20260329012348/FileUni-gui-x86_64-linux-gnu.AppImage"; hash = "sha256-JcS/erGKqcAc/CjQ9GsraIEW7b9Xi+2Zb9490S7E7Yk="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.1_20260329012348/FileUni-gui-aarch64-linux-gnu.AppImage"; hash = "sha256-3672GYPoGPd98UsVFmnh5pWdQHu161fU8fmxqi3tXBo="; };
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
