{ lib, rustPlatform, fetchFromGitHub, git }:

  rustPlatform.buildRustPackage rec {
    pname = "tilth";
    version = "0.9.0";

    src = fetchFromGitHub {
      owner = "jahala";
      repo = "tilth";
      tag = "v${version}";
      hash = "sha256-EETGfQQbDerW4YmVync9RW7asbqRVHK4kOfnnvNjQG4=";
    };

    cargoHash = "sha256-QJki80c8Dt3GzM1cBEIp4voWxkF/awkekAVXQUZahqw=";

    # the diff tests shell out to git
    nativeCheckInputs = [ git ];

    meta = {
      description = "Structural code navigation/search for humans and AI agents";
      homepage = "https://github.com/jahala/tilth";
      license = lib.licenses.mit;
      mainProgram = "tilth";
    };
  }
