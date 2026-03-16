{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.0.4-alpha.4.20260316172913";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.4_20260316172913/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-wFQv0InUqRPlaBsanNlbrf/HLCFk4aVVKBfbSqU39XI="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.4_20260316172913/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-ZRED2f2thd3eVVrjTGVuJtXsnIdbxAG8P0VGJzdOsHw="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.4_20260316172913/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-Bi+wnhjzVT39QLUaS6vcx1Liiy9P39CM43r+7vPRVZA="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.4_20260316172913/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-IB+OmBR+tqPUfXrJg0rxc//a9kya9mego/+5168tasM="; };
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
