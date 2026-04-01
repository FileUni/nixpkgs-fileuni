{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.1";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-H7hqbqsVAx5Fd/igaK47Tkx+VOFKFHfw4PWRKd9UpbU="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-2E/nj565CeYH78C9rVXXC4cbKd0UDz1kkpd7ucdJvb8="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-AYtu93Y/FG82EW53truHUbbzgLo7DFAu/tZwmH6RN9I="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.1/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-oIprhnHCa3SgyDLZwYgLBNYSmPIB8BIB+HKwSgL9XyA="; };
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
