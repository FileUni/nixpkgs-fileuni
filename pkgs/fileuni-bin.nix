{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.7";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.7/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-+FqpsqW6RstjmqdxVvrZsV3aHCzvb6dYaiBIQE8q3FA="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.7/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-5qTTTUL6CtmTG7qGMtCcuGmDqZoHLh5torCKEMPrKNs="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.7/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-dPJlWK+BKbOaq8j6rfHxIpG5H1YyORgfel/+Al9Y+7A="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.7/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-7SR0gwSK/x1x4P8jr3UX9chiymW2YhNttUG/kO+7iaM="; };
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
