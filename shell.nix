{ pkgs ? import ./. {} }:

with pkgs;

mkShell {
  buildInputs = [
    git
    git-hub
    github-release
    hn-node-flush
    hn-rust-clippy
    hn-rust-flush
    hn-rust-fmt
    hn-rust-fmt-check
    qt59.qmake
    which
  ];
}
