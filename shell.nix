{ pkgs ? import ./. {} }:

with pkgs;

mkShell {
  buildInputs = [
    git
    git-hub
    github-release
    qt59.qmake
    which
  ];
}
