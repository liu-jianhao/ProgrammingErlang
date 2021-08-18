-module(answers).
-export([reverse_bytes/1, term_to_packet/1, packet_to_term/1, reverseBits/1]).

%% (1)
reverse_bytes(Bin) ->
  reverse_bytes(Bin, <<>>, 1).

reverse_bytes(Bin, BinRet, Pos) when Pos =< byte_size(Bin) ->
  {Bin1, Bin2} = split_binary(Bin, 1),
  reverse_bytes(Bin2, list_to_binary([Bin1, BinRet]), Pos);
reverse_bytes(Bin, BinRet, Pos) when Pos > byte_size(Bin) ->
  BinRet.

%% (2)
term_to_packet(Term) ->
  Bin = term_to_binary(Term),
  Length = bit_size(Bin),
  Size = <<Length:1/unit:32>>,
  <<Size/binary, Bin/binary>>.

%% (3)
packet_to_term(Packet) ->
  <<Head:32/bits,_/bits>> = Packet,
  <<Size:32>> = Head,
  Length=Size*8,%取bit长度
  <<Head:32/bits,Data:Length/bits>>=Packet,
  binary_to_term(Data).


%% (5)
reverseBits(Bits)->
  lists:reverse([ X || <<X:1>> <= Bits ]).
