final: previous:

with final;

{
  github-release =
    haskell.lib.justStaticExecutables previous.haskellPackages.github-release;

  holochain = {
    hc = lib.warn "holochain.hc is deprecated, use holochain-cli" holochain-cli;
    holochain = lib.warn "holochain.holochain is deprecated, use holochain-conductor" holochain-conductor;
  };

  hc-rust-coverage-install = pkgs.writeShellScriptBin "hc-rust-coverage-install" ''
    if ! cargo --list | grep --quiet tarpaulin;
    then RUSTFLAGS="--cfg procmacro2_semver_exempt" cargo install cargo-tarpaulin;
    fi;
  '';

  hn-flush = writeShellScriptBin "hn-flush" ''
    hn-node-flush
    hn-rust-flush
  '';

  hn-node-flush = writeShellScriptBin "hn-node-flush" ''
    echo "flushing node artifacts"
    find . -wholename "**/node_modules" | xargs -I {} rm -rf {};
  '';

  hn-rust-clippy = writeShellScriptBin "hn-rust-clippy" ''
    echo "submitting to the wrath of clippy"
    cargo clippy -- \
      -A clippy::nursery -A clippy::style -A clippy::cargo \
      -A clippy::pedantic -A clippy::restriction \
      -D clippy::complexity -D clippy::perf -D clippy::correctness
  '';

  # TODO: this is currently dead and segfaults
  # @see https://github.com/xd009642/tarpaulin/issues/190
  hc-rust-coverage = writeShellScriptBin "hn-rust-coverage" ''
    cargo tarpaulin \
      --all \
      --ignore-tests \
      --out Xml \
      --timeout 600 \
      -v \
      -e hc \
      -e hdk \
      -e holochain_core_api_c_binding \
      -e holochain_core_types_derive
  '';

  hc-rust-coverage-codecov = pkgs.writeShellScriptBin "hc-rust-coverage-codecov" ''
    hc-rust-coverage-install && hc-rust-coverage && bash <(curl -s https://codecov.io/bash);
  '';

  hn-rust-flush = writeShellScriptBin "hn-rust-flush" ''
    echo "flushing cargo cache from user home directory"
    rm -rf ~/.cargo/registry;
    rm -rf ~/.cargo/git;

    echo "flushing cargo artifacts and cache from project directories"
    find . -wholename "**/.cargo" | xargs -I {} rm -rf {};
    find . -wholename "**/target" | xargs -I {} rm -rf {};

    echo "flushing cargo lock files"
    find . -name "Cargo.lock" | xargs -I {} rm {};

    echo "flushing binary artifacts from dist"
    rm -rf ./dist;
  '';

  hn-rust-fmt = writeShellScriptBin "hn-rust-fmt" "cargo fmt";

  hn-rust-fmt-check = writeShellScriptBin "hn-rust-fmt-check" ''
    echo "checking rust formatting"
    cargo fmt -- --check
  '';


}
