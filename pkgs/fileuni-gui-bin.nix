{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni-gui";
  version = "0.1.8-alpha.3.20260415010304";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.3_20260415010304/FileUni-gui-x86_64-linux-gnu.zip"; hash = "sha256-k7kcLisN+f7eu+56PwMe5Q373TTskUKwxfCpmGjlqfo="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.3_20260415010304/FileUni-gui-aarch64-linux-gnu.zip"; hash = "sha256-DozXlMeUUCEImg2EXA65nODFSlWi0PepOmHxKsjBDcs="; };
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
