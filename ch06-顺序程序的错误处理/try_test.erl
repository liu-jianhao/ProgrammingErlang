-module(try_test).
-export([demo1/0, demo2/0, demo3/0]).

generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> {'EXIT', a};
generate_exception(5) -> error(a).

demo1() ->
  [catcher(I) || I <- [1,2,3,4,5]].

catcher(N) ->
  try generate_exception(N) of
    Val -> {N, normal, Val}
  catch
    throw:X:Stacktrace ->
      {user, N, caught, throw, X},
      {developer, X, Stacktrace};
    exit:X:Stacktrace ->
      {N, caught, exited, X},
      {developer, X, Stacktrace};
    error:X:Stacktrace ->
      {N, caught, error, X},
      {developer, X, Stacktrace}
  end.

demo2() ->
  [{I, (catch generate_exception(I))} || I <- [1,2,3,4,5]].

demo3() ->
  try generate_exception(5)
  catch
    error:X:Stacktrace ->
      {X, Stacktrace}
  end.