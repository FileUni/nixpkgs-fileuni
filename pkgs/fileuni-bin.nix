{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.0.4-alpha.12.20260319144653";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.12_20260319144653/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-h8paoypptYziQw9Iz023elSBzM+7n8/4vVV8h2jLm1E="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.12_20260319144653/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-mNMkOPbJN8KRet2YJd/Ry1Lq3k34Qvigv9u9xJXmgHQ="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.12_20260319144653/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-0Z8EUstRSZDZ3w9myLC5q4XNGb+AZHCovxKBqUKrYz0="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.12_20260319144653/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-U0dN/v6e+DPLvAA8xzGOi/Yu07zoqH/ddu9DRLXTvVQ="; };
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
