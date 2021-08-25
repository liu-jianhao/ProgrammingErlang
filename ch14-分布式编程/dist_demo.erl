-module(dist_demo).
-export([start/1, rpc/4]).

start(Node) ->
  spawn(Node, fun() ->loop() end).

rpc(Pid, M, F, A) ->
  Pid ! {rpc, self(), M, F, A},
  receive
    {Pid, Response} ->
      Response
  end.

loop() ->
  receive
    {rpc, Pid, M, F, A} ->
      Pid ! {self(), (catch apply(M, F, A))},
      loop()
  end.
