-module(geometry).
-export([area/1]).

area({triangle, Length, Width}) -> Length * Width / 2;
area({circle, Radius}) -> 3.14 * Radius * Radius;
area({rectangle, Width, Height}) -> Width * Height;
area({square, Side}) -> Side * Side.

