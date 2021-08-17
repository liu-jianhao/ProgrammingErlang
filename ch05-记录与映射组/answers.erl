-module(answers).
-export([parse_file/1, map_search_pred/2, pred/2]).
-import(rfc4627, [decode/1]).

%% (1)
parse_file(File) ->
   case file:read_file(File) of
      {ok, Content} -> case rfc4627:decode(Content) of
                          {ok, Result, _} -> Result;
                          {error, Reason} -> io:format("rfc4627:decode error:~p~n", [Reason])
                       end;
     {error, Reason} -> io:format("file:read_file error:~p~n", [Reason])
   end.


%% (2)
map_search_pred(Map, Pred) ->
  map_search_pred(Map, maps:keys(Map), Pred).

map_search_pred(Map, [Key|T], Pred) ->
  case Pred(Key, maps:get(Key, Map)) of
    true -> {Key, maps:get(Key, Map)};
    false -> map_search_pred(Map, T, Pred)
  end;
map_search_pred(_, [], _) ->
  io:format("not found~n").

pred(Key, Value) ->
  case (Key =:= Value) of
    true -> true;
    false -> false
  end.