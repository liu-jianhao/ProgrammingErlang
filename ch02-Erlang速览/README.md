# ch02-Erlang速览

## Hello Wrold

```shell script
$ erl
Eshell V12.0.3  (abort with ^G)
1> c(hello). # 编译
{ok,hello}
2> hello:start().
Hello world
ok
```

```shell script
$ erlc hello.erl
$ erl -noshell -s hello start -s init stop
Hello world
```


## 文件服务进程
```shell script
Eshell V12.0.3  (abort with ^G)
1> c(afile_server).
{ok,afile_server}
2> FileServer = afile_server:start(".").
<0.86.0>
3> FileServer ! {self(), list_dir}.
{<0.79.0>,list_dir}
4> receive X -> X end.
{<0.86.0>,
 {ok,["hello.erl","README.md","afile_server.beam",
      "hello.beam","afile_server.erl"]}}
```


```shell script
Eshell V12.0.3  (abort with ^G)
1> c(afile_server).
{ok,afile_server}
2> c(afile_client).
{ok,afile_client}
3> FileServer = afile_server:start(".").
<0.91.0>
4> afile_client:get_file(FileServer, "missing").
{error,enoent}
5> afile_client:get_file(FileServer, "afile_server.erl").
{ok,<<"-module(afile_server).\n-export([start/1, loop/1]).\n\nstart(Dir) -> spawn(afile_server, loop, [Dir]).\n\nloop(Di"...>>}
```