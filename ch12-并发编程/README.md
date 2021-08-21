# ch12-并发编程

## 课后答案
### (1)
```erlang
start(AnAtom, Fun) ->
  case whereis(AnAtom) of
    undefined ->register(AnAtom, spawn(Fun)),
      io:format("this is process name:~p~n", [AnAtom]);
    Pid -> io:format("this AnAtom have registered pid:~p~n", [Pid])
  end.
```

### (3)
```erlang
start_msg(N, M) ->
  sendstart(M, createProcess(N)).

createProcess(N) ->
  L = for(1, N, fun() -> spawn(fun() -> loop() end) end),
  L.

sendstart(M, L) ->
  Pid = get_pid(1, L, M),
  Pid ! {1, L, M, "hello world"}.

loop() ->
  receive
    {I, L, M, Message} ->
      io:format("Pid:~p Recv Message:~p~n", [(I rem lists_size(L))+1,Message]),
      case get_pid(I+1, L, M) of
        none -> io:format("have send...~n");
        Pid  -> Pid ! {I+1, L, M, Message},
          loop()
      end
  end.

get_pid(I, L, M) ->
  io:format("...........I:~p~n", [I]),
  case lists_size(L) of
    Size when I =< Size ->
      lists:nth(I, L);
    % 注意余数为 0
    Size when I > Size, I rem Size =:= 0 ->
      lists:nth(Size, L);
    Size when I > Size, I =< M ->
      lists:nth((I rem Size), L);
    Size when I > M ->
      none
  end.

for(Max, Max, F) -> [F()];
for(I, Max, F)   -> [F() | for(I+1, Max, F)].


lists_size(L) ->
  lists_size(L, 0).
lists_size([_|T], Size) ->
  lists_size(T, Size+1);
lists_size([], Size) ->
  Size.
```