{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.0.4-alpha.3.20260316152346";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.3_20260316152346/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-EBKZlUt1uX74vOuPTj2rOVVDC19mHT373Fs87IkCLwo="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.3_20260316152346/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-Q1XFtVDEPDNkduFIzAAS0iVmhCWWDGjZy44Z+pvfYOc="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.3_20260316152346/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-JNRl2P6UYfdcusBx2dov/uENEKcXKNs3trP6Ywzs8cs="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.3_20260316152346/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-Dcrlk8Nk8zJCleV/ryZ+0T9i0tUhad2uIol+eYd1Fu8="; };
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
