-module(afile_server).
-export([start/1, loop/1]).

start(Dir) -> spawn(afile_server, loop, [Dir]).

loop(Dir) ->
  receive
    {Client, list_dir} -> %% Client 是发送请求进程的进程标识符
      Client ! {self(), file:list_dir(Dir)}; %% self()是服务器的进程标识符
    {Client, {get_file, File}} ->
      Full = filename:join(Dir, File),
      Client ! {self(), file:read_file(Full)}
  end,
  loop(Dir).
