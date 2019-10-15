# Measuring

1. Running `racket main.rkt` will start measuring.
   You need to modify `config.rkt` first.
   * `BENCHMARKS` are which benchmarks you will be running.
   * `BENCHMARK-ROOT-DIR` is an absolute path string
     to the directory with benchmarks in it.
   * `MODIFIED-TR-DIR` is a directory with the `scv-gt` fork
     of Typed Racket.
   * `ORIGINAL-TR-DIR` is a directory with the normal version
     of Typed Racket.
2. Data collected during the process will be placed in
   in a `measurements/` directory.
3. Generate the figures with `racket figures.rkt`.
4. You may have to run
   `Xvfb -shmem -screen 0 1280x1024x24` and
   `export DISPLAY=:0` in your `~/.profile` to fix
   GTK initialization problems if you're running on a server
   without GTK.
5. `nohup` is allows it to run over `ssh` without
   stopping.
