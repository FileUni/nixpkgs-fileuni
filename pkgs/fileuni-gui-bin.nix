{ lib, stdenvNoCC, appimageTools, fetchurl }:

let
  pname = "fileuni-gui";
  version = "0.1.4-alpha.3.20260403190958";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.4-alpha.3_20260403190958/FileUni-gui-x86_64-linux-gnu.AppImage"; hash = "sha256-Sm9YFPyPdJwWqJZtDPbKmcD9utpnGIQNac4C7SvY3RU="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.4-alpha.3_20260403190958/FileUni-gui-aarch64-linux-gnu.AppImage"; hash = "sha256-8jjTmHigHPo+xwsE6lb1qqfPCccpI/A9y+o2dh1HPhs="; };
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
