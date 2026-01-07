{
  pkg-config,
  lib,
  byond,
  crane',
  clangMultiStdenv,
  buildEnv,
  rustg-repo,
}:
crane'.buildPackage {
  src = import rustg-repo;
  strictDeps = true;

  BYOND_BIN = "${byond}/bin";
  CARGO_BUILD_TARGET = "i686-unknown-linux-gnu";
}
