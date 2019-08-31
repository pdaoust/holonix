{ pkgs ? import ./. {} }:

with pkgs;

mkShell {
  buildInputs = [
    git
    git-hub
    haskellPackages.github-release
    qt59.qmake
    which
  ];
}
