# acquire

## `./tree-adapted.rkt`
Failure: 
```
tree-adapted.rkt:17:9: type-check: type name used out of context
  type: Tree<%>
 in: Tree<%>
  in: Tree<%>
  location...:
   tree-adapted.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./main.rkt`
Failure: 
```
player.rkt:142:32: tile?: unbound identifier
  in: tile?
  location...:
   player.rkt:142:32
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   temp74_0
   ...

```


## `./state.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/acquire/typed/state.rkt:566.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (ext:*create-player *create-player)) (rename-out (ext:state0 state0)) (rename-out (ext:state-place-tile state-place-tile)) (rename-out (ext:state-buy-shares state-buy-shares)) (rename-out (ext:state-return-shares state-return-shar...
  location...:
   state.rkt:566:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 4 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./tree.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/acquire/typed/state.rkt:566.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (ext:*create-player *create-player)) (rename-out (ext:state0 state0)) (rename-out (ext:state-place-tile state-place-tile)) (rename-out (ext:state-buy-shares state-buy-shares)) (rename-out (ext:state-return-shares state-return-shar...
  location...:
   state.rkt:566:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 4 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./player.rkt`
Failure: 
```
player.rkt:142:32: tile?: unbound identifier
  in: tile?
  location...:
   player.rkt:142:32
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./board-adapted.rkt`
Failure: 
```
board-adapted.rkt:25:9: type-check: type name used out of context
  type: Board
 in: Board
  in: Board
  location...:
   board-adapted.rkt:25:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./basics.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/acquire/typed/basics.rkt:192.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (ext:shares-- shares--)) (rename-out (ext:shares-available? shares-available?)) (rename-out (ext:*combine-shares *combine-shares)))
  location...:
   basics.rkt:192:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 4 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./state-adapted.rkt`
Failure: 
```
state-adapted.rkt:96:10: type-check: type name used out of context
  type: Score
 in: Score
  in: Score
  location...:
   state-adapted.rkt:96:10
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 29 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./board.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/acquire/typed/board.rkt:227.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (board make-board)) (rename-out (ext:what-kind-of-spot what-kind-of-spot)) (rename-out (ext:growing-which growing-which)) (rename-out (ext:merging-which merging-which)) (rename-out (ext:merge-hotels merge-hotels)) (rename-out (ext...
  location...:
   board.rkt:227:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 4 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./strategy.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/acquire/typed/board.rkt:227.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (board make-board)) (rename-out (ext:what-kind-of-spot what-kind-of-spot)) (rename-out (ext:growing-which growing-which)) (rename-out (ext:merging-which merging-which)) (rename-out (ext:merge-hotels merge-hotels)) (rename-out (ext...
  location...:
   board.rkt:227:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 4 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./auxiliaries.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/acquire/typed/auxiliaries.rkt:57.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (ext:aux:partition aux:partition)))
  location...:
   auxiliaries.rkt:57:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 4 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./admin.rkt`
Failure: 
```
admin.rkt:278:19: f:->*: bad syntax
  in: (f:->* (g261 g303) (#:show g330) (values g339))
  location...:
   admin.rkt:278:19
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


# dungeon

## `./cell.rkt`
Failure: no contracts

## `./message-queue.rkt`
Failure: no contracts

## `./main.rkt`
Failure: no contracts

## `./utils.rkt`
Failure: no contracts

## `./grid.rkt`
Failure: no contracts

## `./stack.rkt`
Success

# forth

## `./main.rkt`
Failure: 
```
/home/camoy/tmp/soft-contract/soft-contract/fake-contract.rkt:166:40: recursive-contract: must be #:chaperone or #:flat
  in: (#:impersonator)
  location...:
   /home/camoy/tmp/soft-contract/soft-contract/fake-contract.rkt:166:40
  context...:
   do-raise-syntax-error
   success
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:593:8: for-loop
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler1190
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1305
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1305
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler731
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler483
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:187:10: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:165:4: parse-top-level-form
   ...

```


## `./eval.rkt`
Failure: 
```
/home/camoy/tmp/soft-contract/soft-contract/fake-contract.rkt:166:40: recursive-contract: must be #:chaperone or #:flat
  in: (#:impersonator)
  location...:
   /home/camoy/tmp/soft-contract/soft-contract/fake-contract.rkt:166:40
  context...:
   do-raise-syntax-error
   success
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:593:8: for-loop
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler1190
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1305
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1305
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler731
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler483
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:187:10: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:165:4: parse-top-level-form
   ...

```


## `./command.rkt`
Failure: 
```
/home/camoy/tmp/soft-contract/soft-contract/fake-contract.rkt:166:40: recursive-contract: must be #:chaperone or #:flat
  in: (#:impersonator)
  location...:
   /home/camoy/tmp/soft-contract/soft-contract/fake-contract.rkt:166:40
  context...:
   do-raise-syntax-error
   success
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:593:8: for-loop
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler1190
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1305
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1305
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler731
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler483
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:187:10: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:165:4: parse-top-level-form
   ...

```


# fsm

## `./population.rkt`
Failure: 
```
automata-adapted.rkt:34:10: provide: provided identifier is not defined or required
  at: automaton-payoff
  in: (#%provide (expand (provide-trampoline defects cooperates tit-for-tat grim-trigger match-pair automaton-reset clone make-random-automaton automaton-payoff Automaton Probability Population Automaton* Payoff)))
  location...:
   automata-adapted.rkt:34:10
  context...:
   do-raise-syntax-error
   parse-identifier!
   for-loop
   loop
   for-loop
   loop
   [repeats 387 more times]
   resolve-provides113
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   temp74_0
   compile16
   temp68_0
   standard-module-name-resolver
   ...

```


## `./main.rkt`
Failure: 
```
automata-adapted.rkt:34:10: provide: provided identifier is not defined or required
  at: automaton-payoff
  in: (#%provide (expand (provide-trampoline defects cooperates tit-for-tat grim-trigger match-pair automaton-reset clone make-random-automaton automaton-payoff Automaton Probability Population Automaton* Payoff)))
  location...:
   automata-adapted.rkt:34:10
  context...:
   do-raise-syntax-error
   parse-identifier!
   for-loop
   loop
   for-loop
   loop
   [repeats 387 more times]
   resolve-provides113
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   temp74_0
   compile16
   temp68_0
   standard-module-name-resolver
   ...

```


## `./utilities.rkt`
Failure: 
```
utilities.rkt:36:34: f:->*: bad syntax
  in: (f:->* (g14 g16) (#:random g19) (values g20))
  location...:
   utilities.rkt:36:34
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./automata.rkt`
Failure: 
```
automata.rkt:67:9: type-check: type name used out of context
  type: Automaton
 in: Automaton
  in: Automaton
  location...:
   automata.rkt:67:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 10 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./automata-adapted.rkt`
Failure: 
```
automata-adapted.rkt:34:10: automaton-payoff: unbound identifier
  in: automaton-payoff
  location...:
   automata-adapted.rkt:34:10
  context...:
   do-raise-syntax-error
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 22 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/expand.rkt:65:0: do-expand
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:72:2: parse-files
   /home/camoy/tmp/soft-contract/soft-contract/parse/main.rkt:18:2: parse-files
   ...

```


## `./benchmark-util.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/fsm/typed/benchmark-util.rkt:4.2: require/typed/check: bad syntax
  in: require/typed/check
  location...:
   benchmark-util.rkt:4:2
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 3 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   ...

```


# fsmoo

## `./population-adapted.rkt`
Failure: 
```
population-adapted.rkt:17:9: type-check: type name used out of context
  type: oPopulation
 in: oPopulation
  in: oPopulation
  location...:
   population-adapted.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./population.rkt`
Failure: 
```
population.rkt:76:18: f:->*: bad syntax
  in: (f:->* (g94 g93) (#:random g97) (values g98))
  location...:
   population.rkt:76:18
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./main.rkt`
Failure: 
```
population.rkt:76:18: f:->*: bad syntax
  in: (f:->* (g94 g93) (#:random g97) (values g98))
  location...:
   population.rkt:76:18
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./utilities.rkt`
Failure: 
```
utilities.rkt:36:34: f:->*: bad syntax
  in: (f:->* (g14 g16) (#:random g19) (values g20))
  location...:
   utilities.rkt:36:34
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./automata.rkt`
Failure: 
```
/home/camoy/tmp/soft-contract/soft-contract/fake-contract.rkt:166:40: recursive-contract: must be #:chaperone or #:flat
  in: (#:impersonator)
  location...:
   /home/camoy/tmp/soft-contract/soft-contract/fake-contract.rkt:166:40
  context...:
   do-raise-syntax-error
   success
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:593:8: for-loop
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler1190
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1305
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1305
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler731
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler483
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:187:10: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:165:4: parse-top-level-form
   ...

```


## `./automata-adapted.rkt`
Failure: 
```
automata-adapted.rkt:17:9: type-check: type name used out of context
  type: Automaton
 in: Automaton
  in: Automaton
  location...:
   automata-adapted.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


# gregor

## `./difference.rkt`
Failure: no contracts

## `./offset-resolvers.rkt`
Failure: no contracts

## `./core-structs.rkt`
Failure: no contracts

## `./ymd.rkt`
Failure: no contracts

## `./gregor-structs.rkt`
Failure: no contracts

## `./main.rkt`
Failure: no contracts

## `./time.rkt`
Failure: no contracts

## `./hmsn.rkt`
Failure: no contracts

## `./date.rkt`
Failure: no contracts

## `./moment.rkt`
Failure: no contracts

## `./datetime.rkt`
Failure: no contracts

## `./clock.rkt`
Failure: no contracts

## `./moment-base.rkt`
Failure: no contracts

## `./core-adapter.rkt`
Failure: no contracts

## `./tzinfo-adapter.rkt`
Failure: no contracts

## `./gregor-adapter.rkt`
Failure: no contracts

## `./structs-adapter.rkt`
Failure: no contracts

## `./jfif.rkt`
Failure: no contracts

## `./main.rkt`
Failure: no contracts

## `./huffman.rkt`
Failure: no contracts

## `./bit-ports.rkt`
Failure: no contracts

## `./exif.rkt`
Failure: no contracts

# kcfa

## `./denotable.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/kcfa/typed/structs.rkt:129.0: f:provide: unexpected term
  at: ((label g39) (fun g42) (args g43))
  in: (f:provide (f:contract-out (struct (Call Stx) ((label g39) (fun g42) (args g43)))) (f:contract-out (struct Stx ((label g39)))) (f:contract-out (struct (Lam exp) ((label g39) (formals g53) (call g42)))) (f:contract-out (struct (exp Stx) ((label g39)))) (...
  location...:
   structs.rkt:129:42
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./structs-adapted.rkt`
Failure: 
```
structs-adapted.rkt:24:10: type-check: type name used out of context
  type: Exp
 in: Exp
  in: Exp
  location...:
   structs-adapted.rkt:24:10
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 13 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./benv.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/kcfa/typed/structs.rkt:129.0: f:provide: unexpected term
  at: ((label g39) (fun g42) (args g43))
  in: (f:provide (f:contract-out (struct (Call Stx) ((label g39) (fun g42) (args g43)))) (f:contract-out (struct Stx ((label g39)))) (f:contract-out (struct (Lam exp) ((label g39) (formals g53) (call g42)))) (f:contract-out (struct (exp Stx) ((label g39)))) (...
  location...:
   structs.rkt:129:42
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./main.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/kcfa/typed/structs.rkt:129.0: f:provide: unexpected term
  at: ((label g39) (fun g42) (args g43))
  in: (f:provide (f:contract-out (struct (Call Stx) ((label g39) (fun g42) (args g43)))) (f:contract-out (struct Stx ((label g39)))) (f:contract-out (struct (Lam exp) ((label g39) (formals g53) (call g42)))) (f:contract-out (struct (exp Stx) ((label g39)))) (...
  location...:
   structs.rkt:129:42
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./time.rkt`
Failure: 
```
time.rkt:32:19: parameter/c: unbound identifier
  in: parameter/c
  location...:
   time.rkt:32:19
  context...:
   do-raise-syntax-error
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/expand.rkt:65:0: do-expand
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:72:2: parse-files
   /home/camoy/tmp/soft-contract/soft-contract/parse/main.rkt:18:2: parse-files
   ...

```


## `./denotable-adapted.rkt`
Failure: 
```
denotable-adapted.rkt:22:9: type-check: type name used out of context
  type: Denotable
 in: Denotable
  in: Denotable
  location...:
   denotable-adapted.rkt:22:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 12 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./time-adapted.rkt`
Failure: 
```
time-adapted.rkt:19:32: type-check: type name used out of context
  type: Value
 in: Value
  in: Value
  location...:
   time-adapted.rkt:19:32
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 10 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./benv-adapted.rkt`
Failure: 
```
benv-adapted.rkt:25:10: type-check: type name used out of context
  type: BEnv
 in: BEnv
  in: BEnv
  location...:
   benv-adapted.rkt:25:10
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 11 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./ai.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/kcfa/typed/structs.rkt:129.0: f:provide: unexpected term
  at: ((label g39) (fun g42) (args g43))
  in: (f:provide (f:contract-out (struct (Call Stx) ((label g39) (fun g42) (args g43)))) (f:contract-out (struct Stx ((label g39)))) (f:contract-out (struct (Lam exp) ((label g39) (formals g53) (call g42)))) (f:contract-out (struct (exp Stx) ((label g39)))) (...
  location...:
   structs.rkt:129:42
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./structs.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/kcfa/typed/structs.rkt:129.0: f:provide: unexpected term
  at: ((label g39) (fun g42) (args g43))
  in: (f:provide (f:contract-out (struct (Call Stx) ((label g39) (fun g42) (args g43)))) (f:contract-out (struct Stx ((label g39)))) (f:contract-out (struct (Lam exp) ((label g39) (formals g53) (call g42)))) (f:contract-out (struct (exp Stx) ((label g39)))) (...
  location...:
   structs.rkt:129:42
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./ui.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/kcfa/typed/structs.rkt:129.0: f:provide: unexpected term
  at: ((label g39) (fun g42) (args g43))
  in: (f:provide (f:contract-out (struct (Call Stx) ((label g39) (fun g42) (args g43)))) (f:contract-out (struct Stx ((label g39)))) (f:contract-out (struct (Lam exp) ((label g39) (formals g53) (call g42)))) (f:contract-out (struct (exp Stx) ((label g39)))) (...
  location...:
   structs.rkt:129:42
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


# mbta

## `./main.rkt`
Failure: 
```
t-view.rkt:82:19: graph?: unbound identifier
  in: graph?
  location...:
   t-view.rkt:82:19
  context...:
   do-raise-syntax-error
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   temp74_0
   compile16
   temp68_0
   standard-module-name-resolver
   ...

```


## `./run-t.rkt`
Failure: 
```
t-view.rkt:82:19: graph?: unbound identifier
  in: graph?
  location...:
   t-view.rkt:82:19
  context...:
   do-raise-syntax-error
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   temp74_0
   compile16
   temp68_0
   standard-module-name-resolver
   ...

```


## `./t-view.rkt`
Failure: 
```
t-view.rkt:82:19: graph?: unbound identifier
  in: graph?
  location...:
   t-view.rkt:82:19
  context...:
   do-raise-syntax-error
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/expand.rkt:65:0: do-expand
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:72:2: parse-files
   /home/camoy/tmp/soft-contract/soft-contract/parse/main.rkt:18:2: parse-files
   ...

```


## `./t-graph.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/mbta/base/graph/graph/gen-graph.rkt:3.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: all-defined-out
  in: (f:provide (all-defined-out))
  location...:
   /home/camoy/wrk/gtp-benchmarks/benchmarks/mbta/base/graph/graph/gen-graph.rkt:3:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


# morsecode

## `./main.rkt`
Failure: 
```
/home/camoy/wrk/typed-racket/typed-racket-lib/typed-racket/utils/hash-contract.rkt:29:7: flat-contract?: unbound identifier
  in: flat-contract?
  location...:
   /home/camoy/wrk/typed-racket/typed-racket-lib/typed-racket/utils/hash-contract.rkt:29:7
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   lambda-clause-expander
   loop
   [repeats 10 more times]
   module-begin-k
   expand-module16
   ...

```


## `./morse-code-strings.rkt`
Failure: 
```
/home/camoy/wrk/typed-racket/typed-racket-lib/typed-racket/utils/hash-contract.rkt:29:7: flat-contract?: unbound identifier
  in: flat-contract?
  location...:
   /home/camoy/wrk/typed-racket/typed-racket-lib/typed-racket/utils/hash-contract.rkt:29:7
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   lambda-clause-expander
   loop
   [repeats 10 more times]
   module-begin-k
   expand-module16
   ...

```


## `./levenshtein.rkt`
Failure: 
```
match: no matching clause for (-t.@ (-st-ac (-𝒾 'cons 'Λ) 1) '(#<-t.x: listof_174_23159>))
  location...:
   /home/camoy/tmp/soft-contract/soft-contract/reduction/kont.rkt:644:11
  context...:
   /usr/share/racket/collects/racket/match/runtime.rkt:24:0: match:error
   /home/camoy/tmp/soft-contract/soft-contract/reduction/kont.rkt:48:10: ⟦k⟧*
   /home/camoy/tmp/soft-contract/soft-contract/reduction/main.rkt:194:6: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/reduction/main.rkt:191:4: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/reduction/main.rkt:45:4: loop!
   /home/camoy/tmp/soft-contract/soft-contract/reduction/main.rkt:35:2: run
   .../more-scheme.rkt:261:28
   /usr/share/racket/collects/racket/private/more-scheme.rkt:163:2: select-handler/no-breaks
   "/home/camoy/tmp/soft-contract/soft-contract/cmdline.rkt": [running body]
   temp37_0
   for-loop
   run-module-instance!125
   "/usr/share/racket/collects/raco/raco.rkt": [running body]
   temp37_0
   for-loop
   run-module-instance!125
   ...

```


## `./morse-code-table.rkt`
Failure: 
```
/home/camoy/wrk/typed-racket/typed-racket-lib/typed-racket/utils/hash-contract.rkt:29:7: flat-contract?: unbound identifier
  in: flat-contract?
  location...:
   /home/camoy/wrk/typed-racket/typed-racket-lib/typed-racket/utils/hash-contract.rkt:29:7
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   for-loop
   finish-bodys
   lambda-clause-expander
   loop
   [repeats 10 more times]
   module-begin-k
   expand-module16
   ...

```

# sieve

## `./streams.rkt`
Success

## `./main.rkt`
Success

# snake

## `./collide.rkt`
Success

## `./handlers.rkt`
Success

## `./main.rkt`
Success

## `./motion-help.rkt`
Success

## `./motion.rkt`
Success

## `./cut-tail.rkt`
Success

## `./data.rkt`
Success

## `./data-adaptor.rkt`
Failure: 
```
data-adaptor.rkt:27:10: type-check: type name used out of context
  type: Dir
 in: Dir
  in: Dir
  location...:
   data-adaptor.rkt:27:10
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 21 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./const.rkt`
Success

# suffixtree

## `./lcs.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/suffixtree/typed/label.rkt:174.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (ext:make-label make-label)))
  location...:
   label.rkt:174:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 9 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./main.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/suffixtree/typed/label.rkt:174.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (ext:make-label make-label)))
  location...:
   label.rkt:174:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 9 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./typed-data.rkt`
Failure: 
```
typed-data.rkt:17:9: type-check: type name used out of context
  type: Label
 in: Label
  in: Label
  location...:
   typed-data.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./data.rkt`
Success

## `./label.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/suffixtree/typed/label.rkt:174.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (ext:make-label make-label)))
  location...:
   label.rkt:174:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 9 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./ukkonen.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/suffixtree/typed/label.rkt:174.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (ext:make-label make-label)))
  location...:
   label.rkt:174:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 9 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./structs.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/suffixtree/typed/label.rkt:174.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (ext:make-label make-label)))
  location...:
   label.rkt:174:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 9 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


# synth

## `./array-utils.rkt`
Failure: 
```
<pkgs>/typed-racket-lib/typed-racket/base-env/colon.rkt:49.45: quote-syntax: bad syntax
  in: (quote-syntax (:-internal new-js (Vectorof (U A B))) #:local)
  location...:
   /home/camoy/wrk/typed-racket/typed-racket-lib/typed-racket/base-env/colon.rkt:49:45
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler1352
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:593:8: for-loop
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler1190
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1305
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1317
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler1305
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:360:2: parse-es
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./main.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/synth/typed/data.rkt:145.0: f:provide: unexpected term
  at: ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49) (data g51))
  in: (f:provide (f:contract-out (struct Array ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40)))) (f:contract-out (struct (Mutable-Array Settable-Array) ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49)...
  location...:
   data.rkt:156:12
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./array-broadcast.rkt`
Failure: 
```
array-broadcast.rkt:37:19: parameter/c: unbound identifier
  in: parameter/c
  location...:
   array-broadcast.rkt:37:19
  context...:
   do-raise-syntax-error
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/expand.rkt:65:0: do-expand
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:72:2: parse-files
   /home/camoy/tmp/soft-contract/soft-contract/parse/main.rkt:18:2: parse-files
   ...

```


## `./array-struct.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/synth/typed/array-struct.rkt:100.0: f:provide: expected one of these identifiers: `struct-out' or `contract-out'
  at: rename-out
  in: (f:provide (rename-out (Array? array?)) (rename-out (Array-shape array-shape)) (rename-out (Array-size array-size)) (rename-out (Array-unsafe-proc unsafe-array-proc)) make-unsafe-array-proc make-unsafe-array-set-proc)
  location...:
   array-struct.rkt:100:10
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 9 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./typed-data.rkt`
Failure: 
```
typed-data.rkt:17:9: type-check: type name used out of context
  type: Indexes
 in: Indexes
  in: Indexes
  location...:
   typed-data.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./data.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/synth/typed/data.rkt:145.0: f:provide: unexpected term
  at: ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49) (data g51))
  in: (f:provide (f:contract-out (struct Array ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40)))) (f:contract-out (struct (Mutable-Array Settable-Array) ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49)...
  location...:
   data.rkt:156:12
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./mixer.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/synth/typed/data.rkt:145.0: f:provide: unexpected term
  at: ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49) (data g51))
  in: (f:provide (f:contract-out (struct Array ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40)))) (f:contract-out (struct (Mutable-Array Settable-Array) ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49)...
  location...:
   data.rkt:156:12
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./drum.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/synth/typed/data.rkt:145.0: f:provide: unexpected term
  at: ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49) (data g51))
  in: (f:provide (f:contract-out (struct Array ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40)))) (f:contract-out (struct (Mutable-Array Settable-Array) ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49)...
  location...:
   data.rkt:156:12
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./sequencer.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/synth/typed/data.rkt:145.0: f:provide: unexpected term
  at: ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49) (data g51))
  in: (f:provide (f:contract-out (struct Array ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40)))) (f:contract-out (struct (Mutable-Array Settable-Array) ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49)...
  location...:
   data.rkt:156:12
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./synth.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/synth/typed/data.rkt:145.0: f:provide: unexpected term
  at: ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49) (data g51))
  in: (f:provide (f:contract-out (struct Array ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40)))) (f:contract-out (struct (Mutable-Array Settable-Array) ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49)...
  location...:
   data.rkt:156:12
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


## `./array-transform.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/synth/typed/data.rkt:145.0: f:provide: unexpected term
  at: ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49) (data g51))
  in: (f:provide (f:contract-out (struct Array ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40)))) (f:contract-out (struct (Mutable-Array Settable-Array) ((shape g31) (size g29) (strict? g35) (strict! g37) (unsafe-proc g40) (set-proc g49)...
  location...:
   data.rkt:156:12
  context...:
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:730:0: error/report
   /usr/share/racket/collects/syntax/parse/private/runtime-report.rkt:28:0: call-current-failure-handler
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   do-local-expand50
   /usr/share/racket/collects/syntax/wrap-modbeg.rkt:46:4: do-wrapping-module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   finish
   [repeats 2 more times]
   pass-1-and-2-loop
   module-begin-k
   expand-module16
   ...

```


# take5

## `./deck.rkt`
Failure: 
```
stack.rkt:22:30: card?: unbound identifier
  in: card?
  location...:
   stack.rkt:22:30
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   temp74_0
   ...

```


## `./card-adapted.rkt`
Failure: 
```
card-adapted.rkt:17:9: type-check: type name used out of context
  type: Card
 in: Card
  in: Card
  location...:
   card-adapted.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./stack-types.rkt`
Failure: 
```
stack-types.rkt:18:9: type-check: type name used out of context
  type: Stack
 in: Stack
  in: Stack
  location...:
   stack-types.rkt:18:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 7 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./stack.rkt`
Failure: 
```
stack.rkt:22:30: card?: unbound identifier
  in: card?
  location...:
   stack.rkt:22:30
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./main.rkt`
Failure: 
```
player.rkt:57:31: card?: unbound identifier
  in: card?
  location...:
   player.rkt:57:31
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   temp74_0
   ...

```


## `./player.rkt`
Failure: 
```
player.rkt:57:31: card?: unbound identifier
  in: card?
  location...:
   player.rkt:57:31
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./card.rkt`
Success

## `./dealer-types.rkt`
Failure: 
```
dealer-types.rkt:17:9: type-check: type name used out of context
  type: Result
 in: Result
  in: Result
  location...:
   dealer-types.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./player-types.rkt`
Failure: 
```
player-types.rkt:17:9: type-check: type name used out of context
  type: Player%
 in: Player%
  in: Player%
  location...:
   player-types.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./basics-types.rkt`
Failure: 
```
basics-types.rkt:17:9: type-check: type name used out of context
  type: Face
 in: Face
  in: Face
  location...:
   basics-types.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./deck-types.rkt`
Failure: 
```
deck-types.rkt:17:9: type-check: type name used out of context
  type: BaseDeck%
 in: BaseDeck%
  in: BaseDeck%
  location...:
   deck-types.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./dealer.rkt`
Failure: 
```
card-pool.rkt:14:31: card?: unbound identifier
  in: card?
  location...:
   card-pool.rkt:14:31
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   temp74_0
   ...

```


## `./card-pool-types.rkt`
Failure: 
```
card-pool-types.rkt:17:9: type-check: type name used out of context
  type: CardPool%
 in: CardPool%
  in: CardPool%
  location...:
   card-pool-types.rkt:17:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 6 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./basics.rkt`
Success

## `./card-pool.rkt`
Failure: 
```
card-pool.rkt:14:31: card?: unbound identifier
  in: card?
  location...:
   card-pool.rkt:14:31
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


# tetris

## `./bset.rkt`
Success

## `./aux.rkt`
Failure: 
```
match: no matching clause for '#%paramz
  location...:
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:98:4
  context...:
   /usr/share/racket/collects/racket/match/runtime.rkt:24:0: match:error
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:641:2: parse-ref
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler1392
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler483
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:187:10: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:165:4: parse-top-level-form
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:72:2: parse-files
   /home/camoy/tmp/soft-contract/soft-contract/parse/main.rkt:18:2: parse-files
   /home/camoy/tmp/soft-contract/soft-contract/verifier.rkt:28:2: havoc-files
   .../more-scheme.rkt:261:28
   /usr/share/racket/collects/racket/private/more-scheme.rkt:163:2: select-handler/no-breaks
   "/home/camoy/tmp/soft-contract/soft-contract/cmdline.rkt": [running body]
   ...

```


## `./tetras.rkt`
Success

## `./world.rkt`
Failure: 
```
match: no matching clause for '#%paramz
  location...:
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:98:4
  context...:
   /usr/share/racket/collects/racket/match/runtime.rkt:24:0: match:error
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:641:2: parse-ref
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:89:23: fail-handler1392
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /usr/share/racket/collects/syntax/parse/private/runtime.rkt:82:34: fail-handler483
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:187:10: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:165:4: parse-top-level-form
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:72:2: parse-files
   /home/camoy/tmp/soft-contract/soft-contract/parse/main.rkt:18:2: parse-files
   /home/camoy/tmp/soft-contract/soft-contract/verifier.rkt:28:2: havoc-files
   .../more-scheme.rkt:261:28
   /usr/share/racket/collects/racket/private/more-scheme.rkt:163:2: select-handler/no-breaks
   [repeats 1 more time]
   ...

```


## `./consts.rkt`
Success

## `./main.rkt`
Failure: 
```
main.rkt:25:0: type declaration: too many types after identifier
  in: (: replay : World (Listof Any) f:-> Void)
  location...:
   main.rkt:25:0
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   loop
   [repeats 13 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   /home/camoy/tmp/soft-contract/soft-contract/parse/expand.rkt:65:0: do-expand
   /home/camoy/tmp/soft-contract/soft-contract/parse/private.rkt:72:2: parse-files
   /home/camoy/tmp/soft-contract/soft-contract/parse/main.rkt:18:2: parse-files
   /home/camoy/tmp/soft-contract/soft-contract/verifier.rkt:28:2: havoc-files
   .../more-scheme.rkt:261:28
   ...

```


## `./data.rkt`
Success

## `./base-types.rkt`
Failure: 
```
base-types.rkt:29:10: type-check: type name used out of context
  type: Posn
 in: Posn
  in: Posn
  location...:
   base-types.rkt:29:10
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 24 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./block.rkt`
Success

## `./elim.rkt`
Success

# zombie

## `./image.rkt`
Success

## `./main.rkt`
Failure: 
```
zombie.rkt:71:31: image?: unbound identifier
  in: image?
  location...:
   zombie.rkt:71:31
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   temp74_0
   ...

```


## `./zombie.rkt`
Failure: 
```
zombie.rkt:71:31: image?: unbound identifier
  in: image?
  location...:
   zombie.rkt:71:31
  context...:
   do-raise-syntax-error
   for-loop
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./image-adapted.rkt`
Failure: 
```
image-adapted.rkt:20:9: type-check: type name used out of context
  type: Image
 in: Image
  in: Image
  location...:
   image-adapted.rkt:20:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   loop
   [repeats 10 more times]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./math.rkt`
Failure: 
```
Assertion failed on #f
  context...:
   /home/camoy/tmp/soft-contract/soft-contract/reduction/compile.rkt:54:9
   /home/camoy/tmp/soft-contract/soft-contract/reduction/kont.rkt:48:10: ⟦k⟧*
   /home/camoy/tmp/soft-contract/soft-contract/reduction/compile.rkt:183:18: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/reduction/kont.rkt:48:10: ⟦k⟧*
   /home/camoy/tmp/soft-contract/soft-contract/reduction/compile.rkt:183:18: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/reduction/kont.rkt:48:10: ⟦k⟧*
   /home/camoy/tmp/soft-contract/soft-contract/reduction/compile.rkt:183:18: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/reduction/kont.rkt:48:10: ⟦k⟧*
   /home/camoy/tmp/soft-contract/soft-contract/reduction/compile.rkt:183:18: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/reduction/kont.rkt:48:10: ⟦k⟧*
   /home/camoy/tmp/soft-contract/soft-contract/reduction/compile.rkt:183:18: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/reduction/compile.rkt:320:4
   [repeats 19 more times]
   /home/camoy/tmp/soft-contract/soft-contract/reduction/main.rkt:137:4: for-loop
   /home/camoy/tmp/soft-contract/soft-contract/reduction/main.rkt:45:4: loop!
   /home/camoy/tmp/soft-contract/soft-contract/reduction/main.rkt:35:2: run
   ...

```


# zordoz

## `./zo-shell.rkt`
Failure: 
```
zo-string.rkt:167:16: for/list: bad sequence binding clauses
  at: :
  in: (for/list : (Listof stx) ((sx (prefix-stxs z)) #:when sx) sx)
  location...:
   zo-string.rkt:167:16
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 2 more times]
   finish-bodys
   loop
   finish-expanding-body29
   lambda-clause-expander
   loop
   [repeats 30 more times]
   ...

```


## `./main.rkt`
Failure: 
```
zo-string.rkt:167:16: for/list: bad sequence binding clauses
  at: :
  in: (for/list : (Listof stx) ((sx (prefix-stxs z)) #:when sx) sx)
  location...:
   zo-string.rkt:167:16
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 2 more times]
   finish-bodys
   loop
   finish-expanding-body29
   lambda-clause-expander
   loop
   [repeats 30 more times]
   ...

```


## `./zo-find.rkt`
Failure: 
```
zo-string.rkt:167:16: for/list: bad sequence binding clauses
  at: :
  in: (for/list : (Listof stx) ((sx (prefix-stxs z)) #:when sx) sx)
  location...:
   zo-string.rkt:167:16
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   lambda-clause-expander
   for-loop
   [repeats 2 more times]
   finish-bodys
   loop
   finish-expanding-body29
   lambda-clause-expander
   loop
   [repeats 30 more times]
   ...

```


## `./zo-string.rkt`
Failure: 
```
zo-string.rkt:41:36: f:->*: bad syntax
  in: (f:->* (g394) (#:deep? g402) (values g398))
  location...:
   zo-string.rkt:41:36
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   [repeats 1 more time]
   finish-bodys
   loop
   finish-expanding-body29
   loop
   [repeats 1 more time]
   module-begin-k
   expand-module16
   expand-capturing-lifts
   expand-single
   /usr/share/racket/collects/racket/contract/private/arrow-higher-order.rkt:357:33
   ...

```


## `./zo-transition.rkt`
Failure: 
```
/home/camoy/wrk/gtp-benchmarks/benchmarks/zordoz/base/typed-zo-structs.rkt:12:9: type-check: type name used out of context
  type: Spec
 in: Spec
  in: Spec
  location...:
   /home/camoy/wrk/gtp-benchmarks/benchmarks/zordoz/base/typed-zo-structs.rkt:12:9
  context...:
   do-raise-syntax-error
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   for-loop
   loop
   [repeats 4 more times]
   module-begin-k
   do-local-expand50
   /home/camoy/wrk/typed-racket/typed-racket-lib/typed-racket/tc-setup.rkt:94:0: tc-module/full
   /home/camoy/wrk/typed-racket/typed-racket-lib/typed-racket/typed-racket.rkt:23:4: module-begin
   apply-transformer-in-context
   apply-transformer52
   dispatch-transformer41
   ensure-module-begin34
   expand-module16
   ...

```

