{ lib, rustPlatform, git }:

let
  src = fetchGit {
    url = "https://github.com/jahala/tilth";
    rev = lib.fileContents ./tilth.rev;
    shallow = true;
  };
in
  rustPlatform.buildRustPackage {
    pname = "tilth";
    version = (lib.importTOML "${src}/Cargo.toml").package.version;
    inherit src;
    cargoLock.lockFile = "${src}/Cargo.lock";

    # the diff tests shell out to git
    nativeCheckInputs = [ git ];

    meta = {
      description = "Structural code navigation/search for humans and AI agents";
      homepage = "https://github.com/jahala/tilth";
      license = lib.licenses.mit;
      mainProgram = "tilth";
    };
  }
