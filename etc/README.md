# Measuring

A few quick scripts to run experiments.

1. Make sure you have `gtp-measure` installed and have cloned
   the `gtp-benchmark` repo.
2. Running `racket main.rkt` will start measurements with
   `scv-gt`. You have to change `benchmark-dir` to the
   correct directory first.
3. Data collected during the process will be placed in
   in `.dat` files.
4. Run `racket report.rb *.dat` for the full benchmark
   reports in HTML.
5. You may have to run
   `Xvfb -shmem -screen 0 1280x1024x24` and
   `export DISPLAY=:0` in your `~/.profile` to fix
   Gtk initialization problems.
6. `nohup` is allows it to run over `ssh` without
   stopping.
