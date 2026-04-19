{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.10-alpha.3.20260419235940";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.10-alpha.3_20260419235940/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-Q+XgStlUm1xiNOF/c852pOf8MnPWAtQguLNLnBPEowU="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.10-alpha.3_20260419235940/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-9eAKbFCL3nFCH/gI9TKMI3tVHH0Bo/Rn/Dyz6nfL/h8="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.10-alpha.3_20260419235940/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-RDOwT6QD+l7t9XhxR7YI1JmRcDirolV39NVBc/mQe8E="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.10-alpha.3_20260419235940/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-J1mQgz9jeUjyjnHUoIGLUiLBIucXEsIpGqfLgjX0vbQ="; };
  };
  source = sources.${stdenvNoCC.hostPlatform.system}
    or (throw "Unsupported system for FileUni: ${stdenvNoCC.hostPlatform.system}");
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
    install -Dm755 "$sourceRoot/fileuni" "$out/bin/fileuni"
    runHook postInstall
  '';

  meta = with lib; {
    description = "FileUni CLI";
    homepage = "https://fileuni.com";
    mainProgram = "fileuni";
    platforms = builtins.attrNames sources;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
