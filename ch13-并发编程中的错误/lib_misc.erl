-module(lib_misc).
-export([on_exit/2, keep_alive/2]).

on_exit(Pid, Fun) ->
  spawn(fun() ->
    Ref = monitor(process, Pid),
    receive
      {'Down', Ref, process, Pid, Why} ->
        Fun(Why)
    end
  end).

keep_alive(Name, Fun) ->
  register(Name, Pid = spawn(Fun)),
  on_exit(Pid, fun(_Why) -> keep_alive(Name, Fun) end).