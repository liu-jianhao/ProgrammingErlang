-module(lib_misc).
-export([for/3, qsort/1, pythag/1]).

for(Max, Max, F) -> [F(Max)];
for(I, Max, F) -> [F(I)|for(I+1, Max, F)].

%% 快速排序
qsort([]) -> [];
qsort([Pivot|T]) ->
  qsort([X || X <- T, X < Pivot])
  ++ [Pivot] ++
  qsort([X || X <- T, X >= Pivot]).

%% 毕达哥拉斯三元数组，A平方+B平方=C平方
pythag(N) ->
  [ {A, B, C} ||
    A <- lists:seq(1,N),
    B <- lists:seq(1,N),
    C <- lists:seq(1,N),
    A+B+C =< N,
    A*A+B*B =:= C*C
  ].

%% 回文构词
perms([]) -> [[]];
perms(L) -> [[H|T] || H <- L, T <- perms(L--[H])]. %% X -- Y是列表移除操作符，他从X里移除Y中的元素

%% 奇偶数分离
odds_and_evens1(L) ->
  Odds = [X || X <-L, (X rem 2) =:= 1],
  Evens = [X || X <-L, (X rem 2) =:= 0],
  {Odds, Evens}.

odds_and_evens2(L) ->
  odds_and_evens_acc(L, [], []).

odds_and_evens_acc([H|T], Odds, Evens) ->
  case (H rem 2) of
    1 -> odds_and_evens_acc(T, [H|Odds], Evens);
    0 -> odds_and_evens_acc(T, Odds, [H|Evens]);
  end;
odds_and_evens_acc([], Odds, Evens) ->
  {Odds, Evens}.


