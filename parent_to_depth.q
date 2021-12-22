p:0 0 1 0 3 4 3 0 7 8 8 7 11 11 7
d:0 1 2 1 2 3 2 1 2 3 3 2 3 3 2

pd:{0^(raze {y y bin x} prior x)iasc raze x:group x}    / parent from depth
dp:{7h$sum 0<x scan til count x}                 / depth from parent

d~dp pd d
p~pd dp p
