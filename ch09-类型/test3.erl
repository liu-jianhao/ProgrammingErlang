-module(test3).
-export([factorial/1]).

test() -> factorial(-5).

factorial(0) -> 1;
factorial(N) -> N*factorial(N-1).
