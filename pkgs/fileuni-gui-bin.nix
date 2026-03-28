{ lib, stdenvNoCC, appimageTools, fetchurl }:

let
  pname = "fileuni-gui";
  version = "1.0.0-alpha.3.20260329030521";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.3_20260329030521/FileUni-gui-x86_64-linux-gnu.AppImage"; hash = "sha256-PTJWt3RNEDmVQPHpSlFJ2QCqSYTnrF23MNEHexYVUos="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.3_20260329030521/FileUni-gui-aarch64-linux-gnu.AppImage"; hash = "sha256-7pYPo7d14y6rpICSjMyEFsaajfH5K2F5Q8X0RfEuRWM="; };
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
