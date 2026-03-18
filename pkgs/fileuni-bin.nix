{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.0.4-alpha.10.20260318223617";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.10_20260318223617/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-9Ke8cHkW66BY8A886S8+qJL0ZaZv8ODUnTzZv4nLH4o="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.10_20260318223617/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-OkBpC4Dnv+ud7/9+KsPE4bvpn6LmS3/gDGSvxrfvXWQ="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.10_20260318223617/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-rNbM4AeTMtBi+uC4e75GCkQXwDi1Vq1d1B4gxWVkksA="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.10_20260318223617/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-P/DeQnzcMiS21pVTlqBaHjC4qAifPkLgShl1pFF449U="; };
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
