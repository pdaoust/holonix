{ pkgs ? import ./pkgs.nix {} }:

with pkgs;

mkShell {
  buildInputs = [
    binaryen
    binutils
    carnix
    cmake
    coreutils
    curl
    git
    git-hub
    github-release
    hn-node-flush
    hn-rust-clippy
    hn-rust-flush
    hn-rust-fmt
    hn-rust-fmt-check
    openssl
    pkgconfig
    qt59.qmake
    rust.packages.nightly.cargo
    rust.packages.nightly.rustc
    wabt
    wasm-gc
    which
  ];
}
