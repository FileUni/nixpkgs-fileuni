{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.1.5";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.5/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-ELP15HjQSnuXT5UZ7pUlkMfJZRAOgfKKDl24XXFEeUg="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.5/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-DnG6p/nLf8pbJm+D1xlIBwpG/ZkxigSrztTJMwge3O8="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.5/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-0kkhHOzkUFMGioStFTRE0i8CUsdNGuRbmLzcs2m1uMQ="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.1.5/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-dlXQ295FpYZVdQZWf5z18BuQBy/ojZzrwUB2pu7DOx4="; };
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
