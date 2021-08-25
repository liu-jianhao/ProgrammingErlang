-module(answers).
-export([my_spawn/3, my_spawn2/3, start/0, func/1, start2/0, my_spawn3/3,func2/0]).
-import(lib_misc, [on_exit/2]).

%% (1)
my_spawn(Mod, Func, Args) ->
  {Hour1, Minute1, Second1} = time(),
  Pid = spawn(Mod, Func, Args),
  spawn(fun() ->
    Ref = monitor(process, Pid),
    receive
      {'DOWN', Ref, process, Pid, Why} ->
        {Hour2, Minute2, Second2} = time(),
        io:format("error:~p, time:~pS~n", [Why, (Hour2-Hour1)*60*60+(Minute2-Minute1)*60+(Second2-Second1)])
    end
        end),
  Pid.

%% (2)
my_spawn2(Mod, Func, Args) ->
  {Hour1, Minute1, Second1} = time(),
  on_exit(spawn(Mod, Func, Args), fun() -> io:format("error......~n") end),
  {Hour2, Minute2, Second2} = time(),
  io:format("time:~p~n", [(Hour2-Hour1)*60*60 + (Minute2-Minute1)*60 + (Second2-Second1)]).


%% (3)
start() ->
  my_spawn(answers, func, [], 5000).

my_spawn(Mod, Func, _Args, Time) ->
  Pid = spawn(Mod, Func, [Time]),
  io:format("Pid:~p~n", [Pid]),
  spawn(fun() ->
    Ref = monitor(process, Pid),
    receive
      {'DOWN', Ref, process, Pid, Why} ->
        io:format("Pid:~p process quit~n", Pid),
        io:format("Why Quit:~p~n", [Why])
    end
        end),
  Pid.

func(Time) ->
  io:format("Time:~p~n", [Time]),
  receive
    {ok, Message} ->
      io:format("Message:~p~n", Message)
  after Time ->
    exit("timeout")
  end.


%% (4)
start2() ->
  my_spawn3(answers, func2, []).

my_spawn3(Mod, Func, Args) ->
  Pid = spawn(Mod, Func, Args),
  spawn(fun() ->
    Ref = monitor(process, Pid),
    receive
      {'DOWN', Ref, process, Pid, Why} ->
        io:format("接受到消息:~p，正在重启进程~n", [Why]),
        spawn(Mod, Func, Args),
        io:format("重启完毕...~n"),
        monitor(process, Pid)
    end
        end),
  Pid.

func2() ->
  receive
    {ok, Message} ->
      exit(Message)
  after 5000 ->
    io:format("我还在运行~n"),
    func2()
  end.