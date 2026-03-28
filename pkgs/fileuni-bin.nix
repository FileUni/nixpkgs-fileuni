{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "1.0.0-alpha.1.20260329012348";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.1_20260329012348/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-jh9BoF3beRxGfSIasbz5w+A/QlPhTOQrIEjg5KGJhBU="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.1_20260329012348/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-Y9qqJBb25mNu8N6yMVGRVtqYORLUrlZqTLNWSOKmvc8="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.1_20260329012348/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-MKcAPnHgDnwuhGJzFM5dIqNpnH/eQVK/l85JDfvNWz0="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.1_20260329012348/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-TWeBkufDXWa0U1zL5fsvwAYxKZgv9KKC/1HDqo+arCs="; };
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
