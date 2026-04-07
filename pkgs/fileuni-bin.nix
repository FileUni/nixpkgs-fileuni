{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.6-alpha.1.20260407083440";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.6-alpha.1_20260407083440/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-qe8Cz8uCAU3DMz21pv1hzXWhu0e16JMhfLVvhffZw80="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.6-alpha.1_20260407083440/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-q+DtFfiHoAyTKjb2AGjGDgxhbOP7d6yLMwiSeAp/5Mg="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.6-alpha.1_20260407083440/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-s9hlEMC4f18Kj2lRqQOWhMX/AASxvuJ7n80TqUWtTY8="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.6-alpha.1_20260407083440/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-KMD5qlCwTEQz32LDd4N69gtWbzas6GzoyS+Cwt913lc="; };
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
