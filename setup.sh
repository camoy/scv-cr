#!/bin/sh

git clone https://github.com/racket/typed-racket
cd typed-racket
git checkout -b tr-contract v7.0
git apply ../typed-racket.patch
cd typed-racket-lib/
raco pkg install --force
