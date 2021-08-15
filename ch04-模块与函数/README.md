# ch04-模块与函数

- 当函数包含多个不同的子句，会用第一个与调用参数相匹配的子句开始执行

- 逗号分隔函数调用、数据构造和模式中的参数
- 分号分隔子句，如函数定义，以及case、if、try..catch和receive表达式
- 句号分隔函数整体，以及shell里的表达式

## 练习
### (1)
```erlang
area({triangle, Length, Width}) -> Length * Width / 2;
area({circle, Radius}) -> 3.14 * Radius * Radius;
area({rectangle, Width, Height}) -> Width * Height;
area({square, Side}) -> Side * Side.
```

### (2)
- 思路是获取tuple的长度，然后从最后面开始构造list
```erlang
my_tuple_to_list(T) ->
  my_tuple_to_list(T, tuple_size(T), []).

my_tuple_to_list(T, Size, L) when Size =:= 0 ->
  L;
my_tuple_to_list(T, Size, L)  ->
  my_tuple_to_list(T, Size-1, [element(Size, T)|L]).
```

### (3)
my_time_func(F) ->
  {Hour1, Minute1, Second1} = erlang:time(),
  F,
  {Hour2, Minute2, Second2} = erlang:time(),
  io:format("runtime:~f~n", [((Hour2-Hour1)/3600+(Minute2-Minute1)/60+(Second2-Second1))/1000]).
my_date_string() ->
  {Year, Month, Day} = erlang:date(),
  {Hour, Minute, Second} = erlang:time(),
  io:format("~p年~p月~p日~p时~p分~p秒~n", [Year, Month, Day, Hour, Minute, Second]).

### (5)
```erlang
-module(math_functions).
-export([even/1, odd/1]).

even(X) ->
  (X rem 2) =:= 0.

odd(X) ->
  (X rem 2) =:= 1.
```

### (6)
```erlang
filter(F, L) ->
  [X || X <- L, F(X) =:= true].
```

测试：
```shell script
 math_functions:filter(fun(X) -> math_functions:even(X) end, [1, 2, 3, 4, 5]).
```

### (7)
```erlang
split(L) ->
  {filter(fun(X) -> even(X) end, L), filter(fun(X) -> odd(X) end, L)}.
```

测试：
```shell script
40> math_functions:split([1,2,3,4,5,4]).
{[2,4,4],[1,3,5]}
```