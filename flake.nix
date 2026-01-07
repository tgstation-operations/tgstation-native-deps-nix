{
  description = "Flake utils demo";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hacky inputs lol
    rustg-repo = {
      type = "github";
      owner = "tgstation";
      repo = "rust-g";
    };
    dreamluau-repo = {
      type = "github";
      owner = "tgstation";
      repo = "dreamluau";
    };
    byond-zipped = {
      url = "file+https://github.com/spacestation13/byond-builds/raw/refs/heads/master/public/516/516.1675_byond_linux.zip";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    crane,
    fenix,
    rustg-repo,
    dreamluau-repo,
    byond-zipped,
  }:
    flake-utils.lib.eachDefaultSystem (
      localSystem: let
        crossSystem = "i686-unknown-linux-gnu";
        pkgs = (import nixpkgs) {
          inherit localSystem crossSystem;
        };
        lib = pkgs.lib;

        crane' = (crane.mkLib pkgs).overrideToolchain (
          p: (with fenix.packages.${p.stdenv.hostPlatform.system};
            combine (
              with stable; [
                rustc
                cargo
                rust-src
                targets.i686-unknown-linux-gnu.stable.rust-std
              ]
            ))
        );

        byond = pkgs.mkDerivation {
          src = byond-zipped;
          nativeBuildInputs = [pkgs.unzip];

          postBuild = ''
            mkdir -p $out
            ls
            exit 1
          '';
        };

        rustg-crate = pkgs.callPackage ./rust-g.nix {inherit crane' byond rustg-repo;};
        dreamluau-crate = pkgs.callPackage ./dreamluau.nix {inherit crane' byond;};
      in {
        checks = {
          inherit rustg-crate dreamluau-crate;
        };

        packages = {
          default =
            dreamluau-crate
            /*
                                          pkgs.buildEnv {
              name = "tgstation-native-deps";
              paths = [rustg-crate dreamluau-crate];
            }
            */
            ;
          byond = byond;
          librust-g = rustg-crate;
          libdreamluau = dreamluau-crate;
        };
      }
    );
}
