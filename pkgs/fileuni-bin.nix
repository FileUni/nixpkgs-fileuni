{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.8-alpha.1.20260412224510";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.1_20260412224510/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-mPYHr5FveDvkUDzcCTpd3QN50nD0PE1KuyBV8xV6TEA="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.1_20260412224510/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-h9wVN2YyaMmDLrstj3gEsDu2ZEEOxmKOsnN7vxA9+Ls="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.1_20260412224510/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-ClEWA0iUvfQBXJ6re140dq51b5DhE2YqbzkQeUXJmzo="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.1_20260412224510/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-jgFd1Sw4u0Wa4JdzQCuaP/oWj8pyYDGtPEi1+s+cAko="; };
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
