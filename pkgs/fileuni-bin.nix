{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.8-alpha.3.20260415010304";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.3_20260415010304/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-96UxgD4uL4IYo52MrqoC5qelbrJb6/KUdYT/WvcgIzc="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.3_20260415010304/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-EbRcH/5k4nOKUBMhiTmNjyLHQqViBmjHVQZqZsh3xG4="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.3_20260415010304/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-Kk2aIPlrahvBewv5fMFASX4fmYEv5j3egAbQBYTknRU="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.3_20260415010304/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-t0BhNMzPejG0/NYaEokwitwRzXbVhi1QaYLz6Iu3q9c="; };
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
