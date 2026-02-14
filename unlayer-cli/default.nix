{ lib, rustPlatform, ... }:
rustPlatform.buildRustPackage {
  pname = "unlayer-cli";
  version = "1.0.0";

  src =
    let
      fs = lib.fileset;
      fileset = fs.unions [ ./Cargo.toml ./Cargo.lock ./src ];
    in
    fs.toSource { inherit fileset; root = ./.; };

  cargoLock.lockFile = ./Cargo.lock;
}
