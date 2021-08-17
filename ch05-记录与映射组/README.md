# ch05-记录与映射组

- 记录：可以给元组里的各个元素关联一个名称
- 映射组：哈希表

- rr（read records）

- 映射组
    - K => V 更新或者新增
    - K := V 更新，新增会报错
    

## 练习答案
### (1)
需要用到第三方库
```erlang
parse_file(File) ->
   case file:read_file(File) of
      {ok, Content} -> case rfc4627:decode(Content) of
                          {ok, Result, _} -> Result;
                          {error, Reason} -> io:format("rfc4627:decode error:~p~n", [Reason])
                       end;
     {error, Reason} -> io:format("file:read_file error:~p~n", [Reason])
   end.

```

### (2)
```erlang
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
```

测试：
```shell script
19> answers:map_search_pred(#{ a => 1, b => 2, c => c}, fun(Key, Value) -> answers:pred(Key, Value) end).
```