{ ... } @ args: import (import ./vendor/holo-nixpkgs.nix) (args // {
  overlays = [ (import ./overlays/holonix) ] ++ (args.overlays or []);
})
