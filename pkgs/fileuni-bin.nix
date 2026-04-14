{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.9";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.9/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-ytlcQPi7yYMZn1fSXHc3X/GeYfgrxPtan/VyYYmWJK0="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.9/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-4RwbVtC8+7dxLwfyxP5qFC+2c8sw0RQVlSUj0Dtu4TE="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.9/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-ISf/Zo/wMdtHV+Mr9BSVHiG0hmioi5vexs/Irv4aSJU="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.9/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-15f4UhPPZeaLjKkBgi8sjnWL7/WYGRu+UdAq7Bkv/Ic="; };
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
