# ch06-顺序程序的错误处理

## 练习答案

### (1)
```erlang
-module(myfile).
-export([read/1]).

read(File) ->
  try file:read_file(File) of
    {ok, Content} -> Content;
    {error, Reason} -> Reason
  catch
    throw:X -> io:format("throw Reason is:~p~n", [X]);
  end.
```

### (2)
```erlang
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
```