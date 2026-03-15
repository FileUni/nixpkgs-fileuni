{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.0.2-alpha4.11.20260316002214";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.2-alpha4.11_20260316002214/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-neNwcDOVp85rstg7QIVr9L+tBVAO4Hb7kLMuwlrVcZQ="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.2-alpha4.11_20260316002214/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-os6N5C88/QD0nt3GQA+tk1+SofCPJis/4+QFlCokvZU="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.2-alpha4.11_20260316002214/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-dtF5gINGp0DgPL/4J4OIbC4aGxUnO7gOu/eozBAIPHs="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.2-alpha4.11_20260316002214/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-wb74ckpHrablG4hPBi0geBvcAr9Yeq0DPDhrccd3qmk="; };
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
