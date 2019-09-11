let
  base = {
    # set this to "info" to debug compiler cache misses due to fingerprinting
    # @see https://github.com/rust-lang/cargo/issues/4961#issuecomment-359189913
    log = "warnings";

    # set this to "1" or "full" for rust backtraces
    # this is on because we assume you are developing in the shell
    backtrace = "1";

    compile = {
      # @see https://github.com/rust-unofficial/patterns/blob/master/anti_patterns/deny-warnings.md
      deny = "warnings";

      lto = "thinlto";

      # the compiler will split each file into this many chunks and process
      # each in parallel.
      # compilation process is faster with more units but diminishing returns
      # final output supports fewer optimisations with additional units
      # @see https://www.ncameron.org/blog/how-fast-can-i-build-rust/
      codegen-units = "10";

      # the compiler may run this many parallel jobs
      # no real downside of increasing
      # has no additional effect past some point ~6
      # @see https://www.ncameron.org/blog/how-fast-can-i-build-rust/
      # @see NUM_JOBS
      # @see https://doc.rust-lang.org/cargo/reference/environment-variables.html#environment-variables-cargo-sets-for-build-scripts
      jobs = "6";

      # 0 = none
      # 1 = less
      # 2 = default
      # 3 = aggressive
      # s = size
      # z = size min
      optimization-level = "z";
    };
  };

  derived = {
    compile = base.compile // {
      # @see https://llogiq.github.io/2017/06/01/perf-pitfalls.html
      flags ="-D ${base.compile.deny} -Z external-macro-backtrace -Z ${base.compile.lto} -C codegen-units=${base.compile.codegen-units} -C opt-level=${base.compile.optimization-level}";
    };

    test = {
      # test threads can be the same as top level build parallelization
      threads = base.compile.jobs;
    };
  };
in

base // derived
