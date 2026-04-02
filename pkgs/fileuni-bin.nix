{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.2";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.2/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-yfO8p4GTv5jWFNI71PBlLLeFUVBpSE6mwGHIaLwAgxI="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.2/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-ko2XD+BW7x5T3e9pO0dZygsprwaZ5tdci8gOEvmWcMs="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.2/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-8QQqxhhpYYOtTThLWuQundol4P70UB0Qx/mgCvOXUd0="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.2/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-MK+00De3FeL8CnkNc6JTetCwlFgry49HHnZon3Qsyao="; };
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
