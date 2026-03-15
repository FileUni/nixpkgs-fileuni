{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.0.3";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.3/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-G9IdmtXoZi7af0x+BxgHfaxMf6bTMl0VlCZPLcfc238="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.3/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-FMvLnLIDtIqjNdnfYU1vqGU+hlc1qEqbaIyH3vs20Pc="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.3/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-4rI281QKk7ZSTF7ZGdwv02BJJVXlt+nn5oO6u7LnM98="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.3/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-GuHfFSWkct1BJeH/fXVFONbnBqG2jlPEuY/kNC002YY="; };
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
