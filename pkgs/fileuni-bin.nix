{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.0.4-alpha.1.20260316125134";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.1_20260316125134/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-HqtieeCzKbwQIO5wxp2wZzlE2zMKkB3nw7f/zzV5PHU="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.1_20260316125134/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-X4BOI9VN/2Aus6S7HH2XXemCJl6s78g66FbG5z/Gcho="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.1_20260316125134/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-L14oVUi8rxgzb1+myqAAnjVRUAAKE2hw6dKiE1jyBhQ="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.1_20260316125134/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-F8eeYeB3Ko891uEic7rHZy8Szy+4a6wL9Zg5rLKwWSw="; };
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
