final: previous:

with final;

{
  github-release =
    haskell.lib.justStaticExecutables previous.haskellPackages.github-release;

  holochain = {
    hc = holochain-cli;
    holochain = holochain-conductor;
  };
}
