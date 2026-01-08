{
  stdenv,
  autoPatchelfHook,
  unzip,
  libpng,
  curl,
  byond-zipped,
}:
stdenv.mkDerivation {
  pname = "byond";
  version = "516.1675";

  src = byond-zipped;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libpng
    curl
    stdenv.cc.cc.lib
  ];

  autoPatchelfFlags = ["--keep-libc"];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R bin $out
    runHook postInstall
  '';
}
