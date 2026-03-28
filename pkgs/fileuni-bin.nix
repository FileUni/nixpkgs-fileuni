{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "1.0.0-alpha.3.20260329030521";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.3_20260329030521/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-skDpGEL5fG3T5Q0g4gy3r7uXhTzHuFXmdnbiVX01cWY="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.3_20260329030521/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-m7oPIbGKfmBzo2HZ7xBnO0p1s/rhe2duXN6Vh+8X3tY="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.3_20260329030521/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-4E1sp8x+BB50thpi4VIzeLLUqpCL1MW55CuC0P7zUKw="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v1.0.0-alpha.3_20260329030521/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-Yxym3ORcCZhbBRdMhoB9t+3H2p9f6T3AfqTpVxvpNAU="; };
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
