{ ... } @ args: import (import ./vendor/holo-nixpkgs.nix) (args // {
  overlays = [ (import ./overlay) ] ++ (args.overlays or []);
})
