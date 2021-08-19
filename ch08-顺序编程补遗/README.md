# ch08-顺序编程补遗

## 课后答案

### (2)
```erlang
-module(answers).
-export([get_max_func_mod/0, get_most_common_func/0, get_once_func/0]).

list_size(L) ->
  list_size(L, 0).

list_size([_|T], Size) ->
  list_size(T, Size+1);
list_size([], Size) ->
  Size.

%% 最多导出函数的模块
get_max_func_mod() ->
  get_max_func_mod("", code:all_loaded(), -1).

get_max_func_mod(_, [H|T], Max) ->
  {Name, _} = H,
  [_, {exports, L}, _, _, _] = Name:module_info(),
  case (list_size(L) > Max) of
    true -> get_max_func_mod(Name, T, list_size(L));
    false -> get_max_func_mod(Name, T, Max)
  end;
get_max_func_mod(Mod, [], Max) ->
  {Mod, Max}.

%% 最常见的函数名
get_most_common_func() ->
  get_most_common_func(code:all_loaded(), #{}).

get_most_common_func([H|T], Map) ->
  {Name, _} = H,
  [_, {exports, L}, _, _, _] = Name:module_info(),
  get_most_common_func(T, count_func(L, Map));
get_most_common_func([], Map) ->
  find_max(Map).

count_func([H|L], Map) ->
  {Func, _} = H,
  case maps:is_key(Func, Map) of
    true -> count_func(L, Map#{Func => maps:get(Func, Map)+1});
    false -> count_func(L, Map#{Func => 1})
  end;
count_func([], Map) ->
  Map.

find_max(X) ->
  L = maps:keys(X),
  find_max(L, X, "", -1).

find_max([H|T], X, MaxKey, MaxValue) ->
  {ok, Value} = maps:find(H, X),
  case (Value > MaxValue) of
    true  -> find_max(T, X, H, Value);
    false -> find_max(T, X, MaxKey, MaxValue)
  end;
find_max([], _, MaxKey, MaxValue) ->
  {MaxKey, MaxValue}.

%% 只出现过一次的函数
get_once_func() ->
  get_once_func(code:all_loaded(), #{}).

get_once_func([H|T], Map) ->
  {Name, _} = H,
  [_, {exports, L}, _, _, _] = Name:module_info(),
  get_once_func(T, count_func(L, Map));
get_once_func([], Map) ->
  find_one(Map).

find_one(Map) ->
  Keys = maps:keys(Map),
  lists:filter(fun(K) -> {ok, Value} = maps:find(K, Map), Value =:= 1 end, Keys).
```