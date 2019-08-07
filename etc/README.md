# Measuring

A few quick scripts to run experiments.

1. Make sure you have `gtp-measure` installed and have cloned
   the `gtp-benchmark` repo.
2. Running `racket main.rkt` will start measurements with
   `scv-gt`. You have to change `benchmark-dir` to the
   correct directory first.
3. Data collected during the process will be placed in
   in `.dat` files.
4. Run `racket report.rkt *.dat` for the full benchmark
   reports in HTML.
5. You may have to run
   `Xvfb -shmem -screen 0 1280x1024x24` and
   `export DISPLAY=:0` in your `~/.profile` to fix
   GTK initialization problems if you're running on a server
   without GTK.
6. `nohup` is allows it to run over `ssh` without
   stopping.
7. Note that `main.rkt` will **not** setup when
   `~/.config/share/gtp-measure` already has configurations.
   It will delete stale `.out` files, but not generate new
   `.in` files.

   In other words, you can run measurements consecutively
   and get the appropriate results (i.e. using the same
   configurations, but perhaps running one with `scv-gt`
   and one without). Just make sure that your consecutive
   runs are compatible (e.g. that you aren't running one
   with some benchmarks missing).
