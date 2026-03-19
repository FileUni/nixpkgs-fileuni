{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.0.4";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-yNUNEkh1RHOYkgCl+qiovqko+Cj6VTZVGqGgfWcz9p0="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-yf4o2Tiuu/NE5IuaRrEGj6CZpTBEV1QEmNhM1ApO5yQ="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-DeWBpF5rc5+lczoLrKYcuEjRUZxBjnsm5206iaFXVWM="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-V/957WiCTGCt05USIyxDGuKAl5yVf1AiWmBTZmjAlzk="; };
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
