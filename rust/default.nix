{ pkgs }:
let
  rust = import ./config.nix;
in
rust //
{
 buildInputs = []
 ++ (pkgs.callPackage ./clippy { }).buildInputs
 ++ (pkgs.callPackage ./coverage { }).buildInputs
 ++ (pkgs.callPackage ./fmt { }).buildInputs
 ++ (pkgs.callPackage ./manifest { }).buildInputs
 ++ (pkgs.callPackage ./wasm { }).buildInputs
 ++ (pkgs.callPackage ./flush { }).buildInputs
 ++ (pkgs.callPackage ./test { rust = rust; }).buildInputs
 ;
}
