-module(myfile).
-export([read/1]).

read(File) ->
  try file:read_file(File) of
    {ok, Content} -> Content;
    {error, Reason} -> Reason
  catch
    throw:X -> io:format("throw Reason is:~p~n", [X]);
  end.