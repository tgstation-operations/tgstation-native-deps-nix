{
  byond,
  crane',
  rustg-repo,
}:
crane'.buildPackage {
  src = rustg-repo;
  strictDeps = true;

  BYOND_BIN = "${byond}/bin";
  CARGO_BUILD_TARGET = "i686-unknown-linux-gnu";
}
