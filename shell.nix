{ pkgs ? import ./. {} }:

with pkgs;

mkShell {
  buildInputs = [
    git
    git-hub
    github-release
    hn-node-flush
    qt59.qmake
    which
  ];
}
