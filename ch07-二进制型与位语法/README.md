# ch07-二进制型与位语法

- binary -> 位数是8的倍数
- bitstring -> 位数不是8的倍数

- <<<"hello">>

## 课后答案
### (1)
```erlang
reverse_bytes(Bin) ->
  reverse_bytes(Bin, <<>>, 1).

reverse_bytes(Bin, BinRet, Pos) when Pos =< byte_size(Bin) ->
  {Bin1, Bin2} = split_binary(Bin, 1),
  reverse_bytes(Bin2, list_to_binary([Bin1, BinRet]), Pos);
reverse_bytes(Bin, BinRet, Pos) when Pos > byte_size(Bin) ->
  BinRet.
```

### (2)
```erlang
term_to_packet(Term) ->
  Bin = term_to_binary(Term),
  Length = bit_size(Bin),
  Size = <<Length:1/unit:32>>,
  <<Size/binary, Bin/binary>>.
```

### (3)
```erlang
packet_to_term(Packet) ->
  <<Head:32/bits,_/bits>> = Packet,
  <<Size:32>> = Head,
  Length=Size*8,%取bit长度
  <<Head:32/bits,Data:Length/bits>>=Packet,
  binary_to_term(Data).
```

### (5)
```erlang
reverseBits(Bits)->
  lists:reverse([ X || <<X:1>> <= Bits ]).
```
