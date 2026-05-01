{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.12-alpha.3.20260502053403";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.12-alpha.3/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-xf1Ckf3jWQ262aNnJSF1HGuN4GigJ7dCocPtAz9XrKI="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.12-alpha.3/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-6XEFKgucNkfJOiN6sn1TxcPYbT+urubQtGPUYqGfdWY="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.12-alpha.3/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-q5eJ7ktvawbl6ctaE4jWKXI0N4u1IDT2Sjf1W/X0FSM="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.12-alpha.3/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-cC3Nsg0oLhGaDRV0wGCqMmQIK2mj/xrhYlEOurZq6wI="; };
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
