{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni-gui";
  version = "0.1.12-alpha.3.20260502053403";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.12-alpha.3/FileUni-gui-x86_64-linux-gnu.zip"; hash = "sha256-I34ZE23VUm1dvnfprcaFy5DArs+vY4hC4SAroORfQTw="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.12-alpha.3/FileUni-gui-aarch64-linux-gnu.zip"; hash = "sha256-WpfaA9vu+RtY7WmzmI3nPA8Y83VCncT7vr8oowPYv4Q="; };
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
