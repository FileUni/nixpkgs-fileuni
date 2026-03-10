{ lib, stdenvNoCC, fetchzip }:

let
  pname = "fileuni";
  version = "0.0.2-alpha2";
  sources = {
    "x86_64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.2-alpha2/FileUni-cli-x86_64-linux-gnu.zip"; hash = "sha256-0wbSaBIn6W0F2zZbNsef54qqp9FFKAqnjgEH9Oc7pzY="; };
    "aarch64-linux" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.2-alpha2/FileUni-cli-aarch64-linux-gnu.zip"; hash = "sha256-AscTq1z+VNeUIn8ovUj9PK15jSHbF9tizDmDlLZvmCo="; };
    "x86_64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.2-alpha2/FileUni-cli-x86_64-macos-darwin.zip"; hash = "sha256-P9zefoQM6jdSQBIktM1pbY46DjLH28p7NTa3JLzlrZo="; };
    "aarch64-darwin" = { url = "https://github.com/FileUni/FileUni-Project/releases/download/FileUni-v0.0.2-alpha2/FileUni-cli-aarch64-macos-darwin.zip"; hash = "sha256-mUF/35DUWHHIssR5YNdujYJBMBB9LAz5tGxUvmLCpGM="; };
  };
  source = sources.${stdenvNoCC.hostPlatform.system}
    or (throw "Unsupported system for FileUni: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = source.url;
    hash = source.hash;
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src/fileuni" "$out/bin/fileuni"
    runHook postInstall
  '';

  meta = with lib; {
    description = "FileUni CLI";
    homepage = "https://fileuni.com";
    mainProgram = "fileuni";
    license = licenses.unfree;
    platforms = builtins.attrNames sources;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
