{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.12";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.12/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-q3+1XljuE68Rf8q9+b7qHKGC+lbNglKTinw5+169Q0U="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.12/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-2Qv0jzQuaOc2I9vquKW0MNjwN963kKFo86ri1Q1npZE="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.12/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-8oWNSifEVPzwUgGpYpOL1VrbplQPEwnMJc2OfZnuWxI="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.12/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-zF+F2Rytbgu7dd1ybCeWZ3s0LgQOqrOAzAwkpiFgDoM="; };
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
