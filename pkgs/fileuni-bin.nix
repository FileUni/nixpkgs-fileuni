{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.0.4-alpha.9.20260317182019";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.9_20260317182019/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-f8KyAbr+pYTwSTz6DlTsiiuwuApwM/0iv4ISxfDd7Xs="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.9_20260317182019/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-kzvFj8saJsr0w1wTf6HVUpQcSBGmEpwPvnbcKFb/AMg="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.9_20260317182019/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-fSgtQGJtfhmAxlN11McC03XsteY240CHmN70oWpbYN0="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.9_20260317182019/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-xFpnbYZ/E5p8cfu25C+b5L3+qE/h3U6jgzScaDwt548="; };
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
