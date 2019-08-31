final: previous:

with final;

{
  github-release =
    haskell.lib.justStaticExecutables previous.haskellPackages.github-release;

  holochain = {
    hc = lib.warn "holochain.hc is deprecated, use holochain-cli" holochain-cli;
    holochain = lib.warn "holochain.holochain is deprecated, use holochain-conductor" holochain-conductor;
  };
}
