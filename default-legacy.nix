# This is the default nix file FOR HOLONIX
# This file is what nix will find when hitting this repo as a tarball
# This means that downstream consumers should pkgs.callPackage this file
# See example.default.nix for an example of how to consume this file downstream
{
 # allow consumers to pass in their own config
 # fallback to empty sets
 config ? import ./config.nix
}:
let
 pkgs = import ./nixpkgs;

 app-spec-cluster = pkgs.callPackage ./app-spec-cluster { };
 rust = pkgs.callPackage ./rust { };
 dist = pkgs.callPackage ./dist {
  rust = rust;
 };
 release = pkgs.callPackage ./release {
  config = config;
 };
 test = pkgs.callPackage ./test {
   pkgs = pkgs;
 };

 holonix-shell = pkgs.callPackage ./nix-shell {
  pkgs = pkgs;
  app-spec-cluster = app-spec-cluster;
  dist = dist;
  release = release;
  rust = rust;
  test = test;
 };

 # override and overrideDerivation cannot be handled by mkDerivation
 derivation-safe-holonix-shell = (removeAttrs holonix-shell ["override" "overrideDerivation"]);
in
{
 # export the set used to build shell alongside the main derivation
 # downstream devs can extend/override the shell as needed
 # holonix-shell provides canonical dev shell for generic work
 shell = derivation-safe-holonix-shell;
 main = pkgs.stdenv.mkDerivation derivation-safe-holonix-shell;

 # expose other things
 rust = rust;
}
