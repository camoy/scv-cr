#!/bin/sh

git clone https://github.com/racket/typed-racket
cd typed-racket
git checkout -b tr-contract v7.1
cd typed-racket-lib/
raco pkg install --force
git apply ../../typed-racket.patch
