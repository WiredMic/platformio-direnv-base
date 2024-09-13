{
  description = "A basic flake with a shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {

          packages = with pkgs; [ platformio nix-ld python3 clang-tools ];

          NIX_LD_LIBRARY_PATH = nixpkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc
            pkgs.openssl
            # ...
          ];
          # NIX_LD = nixpkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";

          shellHook = ''
            export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH

            # Make the directory more portable
            mkdir ./.platformio-dir
            export PLATFORMIO_CORE_DIR=./.platformio-dir
          '';
        };
      });
}

# https://docs.platformio.org/en/latest/integration/ide/emacs.html
