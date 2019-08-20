#lang scribble/manual
@require[@for-label[racket/base]]

@title[#:tag "top"]{SCV GT}
@author[(author+email "Cameron Moy" "camoy@cs.umd.edu")]
@defmodule[scv-gt]

Soft contract verification for gradually-typed programs.

@section{Command Line}

The @exec{raco scv-gt} command allows you to optimize Typed
Racket programs using soft contract verification. It does
so by extracting the contracts generated by Typed Racket,
passing them to @exec{scv} for verification, and eliminating
all contracts that are proven safe statically. Simply pass
your files to @exec{raco scv-gt} and optimized bytecode will
be created.

The @exec{raco scv-gt} command accepts the following
command-line flags:

@itemlist[
@item{
  @exec{-s} or @exec{--show-contracts} --- print the target
  modules with their contracts attached.
}

@item{
  @exec{-k} or @exec{--keep-contracts} --- don't erase
  contracts that have been verified.
}

@item{
  @exec{-p} or @exec{--show-optimized} --- print and overwrite
  optimized code instead of the pre-verified code with contracts.
}

@item{
  @exec{-b} or @exec{--show-blames} --- output blame information
  from @exec{scv}.
}

@item{
  @exec{-i} or @exec{--ignore-check} --- turn all invocations
  of @code{require-typed/check} into @code{require-typed}. This
  forces a double layer of contracts at every typed-typed module
  boundary.
}

@item{
  @exec{-o} or @exec{--overwrite} --- overwrite original
  source files with the a version with optimized contracts.
}

@item{
  @exec{-c} or @exec{--compiler-off} --- don't compile the
  targets into zo files.
}

@item{
  @exec{-v} or @exec{--verify-off} --- don't pass the modules
  through @exec{scv}.
}
]

@section{Reference}

@defproc[(optimize [targets (or/c path-string? path-for-some-system?)]
                   [#:show-contracts show-contracts #f boolean?]
                   [#:keep-contracts keep-contracts #f boolean?]
                   [#:show-optimized show-optimized #f boolean?]
                   [#:show-blames show-blames #f boolean?]
                   [#:ignore-check ignore-check #f boolean?]
                   [#:overwrite overwrite #f boolean?]
                   [#:compiler-off compiler-off #f boolean?]
                   [#:verify-off verify-off #f boolean?])
         void?]{
Optimize @racket[targets] as described above.
}
