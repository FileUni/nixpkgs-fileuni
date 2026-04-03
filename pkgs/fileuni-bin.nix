{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.4-alpha.3.20260403190958";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.4-alpha.3_20260403190958/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-k815HYlK3oHOxiVOSEgRSZEZX9+MjXY3x4xGF5nPHR8="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.4-alpha.3_20260403190958/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-Waun12rnbsE+2s3p+GxeClS/vCJdnBpi5uYj1ZLa1UA="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.4-alpha.3_20260403190958/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-hNaIg8XylWRFnbwfCJICuOAQwvwi2lz6LrC3OAx93gM="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.4-alpha.3_20260403190958/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-2oHJvrVdLMrsYPZYf3iaARgyw8+GO5mrBCKYFKPcyiY="; };
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
