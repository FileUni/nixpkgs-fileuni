{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.10-alpha.1.20260415133208";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.10-alpha.1_20260415133208/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-BqTGVLmsksI3YqOwNXIy+rBwultzcsZ+nNx4os7cBQY="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.10-alpha.1_20260415133208/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-Ka+3t5Hr72jmeARIMSw7FgbZqDYuyjeAx23UAzvNZXk="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.10-alpha.1_20260415133208/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-pe2MDeOxGjWHLvoWAEliFgadmEgUnfSApd/Pgsnp/sE="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.10-alpha.1_20260415133208/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-6QrGkCHue5Pn579uC7T8cedEwcKBXpXoGhZ8ivEoPPs="; };
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
