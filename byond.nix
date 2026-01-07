{
  stdenv,
  autoPatchelfHook,
  unzip,
  libpng,
  curl,
}:
stdenv.mkDerivation {
  pname = "byond";
  version = "516.1675";

  src = ./byond.zip;

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
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
