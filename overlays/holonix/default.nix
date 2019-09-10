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

  hc-rust-manifest-install = pkgs.writeShellScriptBin "hc-rust-manifest-install" ''
    cargo install cargo-edit
  '';

  hc-rust-manifest-list-unpinned = pkgs.writeShellScriptBin "hc-rust-manifest-list-unpinned" ''
    find . -type f \( -name "Cargo.toml" -or -name "Cargo.template.toml" \) | xargs cat | grep -Ev '=[0-9]+\.[0-9]+\.[0-9]+' | grep -E '[0-9]+' | grep -Ev '(version|edition|codegen-units|{ git = ".*", rev = "\w+" })' | cat
  '';

  hc-rust-manifest-set-ver = writeShellScriptBin "hc-rust-manifest-set-ver" ''
    # node dist can mess with the process
    hc-node-flush
    find . -name "Cargo.toml" | xargs -I {} cargo upgrade "$1" --all --manifest-path {}
  '';

  hc-rust-manifest-test-ver = writeShellScriptBin "hc-rust-manifest-test-ver" ''
    # node dists can mess with the process
    hc-node-flush

    # loop over all tomls
    # find all possible upgrades
    # ignore upgrades that are just unpinning themselves (=x.y.z will suggest x.y.z)
    # | grep -vE 'v=([0-9]+\.[0-9]+\.[0-9]+) -> v\1'
    echo "attempting to suggest new pinnable crate versions"
    find . -name "Cargo.toml" | xargs -P "$NIX_BUILD_CORES" -I {} cargo upgrade --dry-run --allow-prerelease --all --manifest-path {} | grep -vE 'v=[0-9]+\.[0-9]+\.[0-9]+'

    hc-rust-manifest-list-unpinned
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

  hc-rust-test = pkgs.writeShellScriptBin "hc-rust-test" ''
    hc-rust-wasm-compile && HC_SIMPLE_LOGGER_MUTE=1 RUST_BACKTRACE=1 cargo test --all --release --target-dir "$HC_TARGET_PREFIX"target "$1" -- --test-threads=${rust.test.threads};
  '';
}
