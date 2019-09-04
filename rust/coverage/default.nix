{ pkgs }:
{
 buildInputs =
 [
 ]
 ++ (pkgs.callPackage ./codecov { }).buildInputs
 ++ (pkgs.callPackage ./coverage { }).buildInputs
 ++ (pkgs.callPackage ./install { }).buildInputs
 ;
}
