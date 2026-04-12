{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.8-alpha.2.20260413065435";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.2_20260413065435/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-T9wgv4N642LZbiKdbvhzyIDO6D+7A91tyJHENtyW9m0="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.2_20260413065435/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-glqMGpXfZuP1FkuBVKMkpiXdY0j/HPKaXniL2PrgcSM="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.2_20260413065435/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-/fINHeUO7J+JIx4MuqzV+p87IB/FN/JDRRinQdYYMH8="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.8-alpha.2_20260413065435/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-69+LlI1WAbK27N4DCU2zJubyIZ2z7NhksqTCX1O+Aj8="; };
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
