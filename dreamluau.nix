{
  crane',
  byond,
  buildEnv,
  llvmPackages,
  pkgsBuildHost,
  pkgsBuildBuild,
  breakpointHook,
  gcc-unwrapped,
}: let
  src = ./dreamluau;

  # patch clang-sys due to incorrect usage of cfg!() instead of environment variables
  cargoVendorDir = crane'.vendorMultipleCargoDeps {
    cargoLockList = [
      (src + /Cargo.lock)
    ];
    cargoLockContentsList = [
      ''
        [[package]]
        name = "build-target"
        version = "0.8.0"
        source = "registry+https://github.com/rust-lang/crates.io-index"
        checksum = "78e2ceaf91e22593e194211930aea78a41af58e49e872474ebf4335bf649aad1"
      ''
    ];
    overrideVendorCargoPackage = p: drv:
    # patch clang-sys
      if p.name == "clang-sys"
      then
        drv.overrideAttrs (
          old: {
            patches = [
              ./001-clang-sys-target-macros.patch
            ];
          }
        )
      else drv;
  };
in
  crane'.buildPackage {
    inherit src;
    strictDeps = true;

    cargoCheckExtraFlags = ""; # specifying --locked during check makes cargo freak out fsr

    nativeBuildInputs = [
      breakpointHook
    ];

    buildInputs = [
      pkgsBuildHost.libgcc.lib
    ];

    BYOND_BIN = "${byond}/bin";
    CARGO_BUILD_TARGET = "i686-unknown-linux-gnu";
    LIBCLANG_PATH = "${pkgsBuildHost.llvmPackages.libclang.lib}/lib";
  }
