{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.1-alpha.1.20260401184702";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1-alpha.1_20260401184702/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-DcDN6U56h8tAEzIMGJm67UQ5i31TqKULjo36DihPsFQ="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1-alpha.1_20260401184702/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-fl52JUmGfLDUgLEOruFk4HHk5dLwzk835BlFK6Y/kAo="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1-alpha.1_20260401184702/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-tPDfMmvVNjUtxP6QBihk4+SyA2ZV9Zgg3ZBJPxPRAmI="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1-alpha.1_20260401184702/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-KCRjZSh6WonlEFFHwWNJWZ1FDlE3wu7LIYulha1FjB0="; };
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
