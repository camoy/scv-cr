# tr-contract

This package converts a Typed Racket module into a module with explicit contracts.

## Using

Running `raco explicit-contracts typed-module.rkt` will print an equivalent untyped module that is protected by contracts.

Running `raco explicit-contracts -i typed-module.rkt` replaces the file instead of printing.

If you give the command multiple files it will process all of them. Any file not written in Typed Racket will be ignored.

## Installing

Run `raco pkg install` from the directory. You'll also need to install a hacked version of Typed Racket. You can run `etc/setup.sh` to do so. This will download TR, patch it, and force install the new version.

You also need to patch your installation of SCV with `etc/scv.patch`.
