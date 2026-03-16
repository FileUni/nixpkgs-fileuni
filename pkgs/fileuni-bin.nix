{ lib, stdenvNoCC, fetchurl, unzip }:

let
  pname = "fileuni";
  version = "0.0.4-alpha.2.20260316142031";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.2_20260316142031/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-Z7NbI4dHyfaOgsOH0pChja91ox5fd/3piBBzqgLqtsI="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.2_20260316142031/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-Zc/zEquWHIyVAjKh7eoapp8rYzXOn6LFSIieivVCXdg="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.2_20260316142031/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-03HFsyHeBt1RhFddKEGwcADUdNGJZFdocvW641P8a+0="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.4-alpha.2_20260316142031/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-+s5hQ1FZdIGRUwlGgAkwZ6Sab6/k8qxQyFFSFaSYYgA="; };
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
