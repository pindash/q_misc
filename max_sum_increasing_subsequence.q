/Leet Code contiguous 1800
nums:10,20,30,5,10,50
max sum each (0,where 0>deltas nums) cut nums

/Non Contiguous https://www.geeksforgeeks.org/maximum-sum-increasing-subsequence-dp-14/
/NGN's solution
|/{x,a|/(-1_y<a)*x+a:*|y}/,\
i:{x where x<y}'[where each x</:x;til count x]
i:{where last[x]>x} each (,\)x
i:where each til[count x]#'x</:x
{@[x;z;+;0|max x y]}/[n;i;til count x]
and we can even do it in place 
get @[`x;::;{x+0|max `x y};i]


/ben's solution work backwards 
a:1 99 2 3 100 9 4 5 8 10
as:{1 _ x} scan reverse a
f:{1 _ @[x;i where differ maxs y i:where first[y]>y;+;first x]}
f[reverse a;reverse a]
f scan enlist[reverse a],as
/
10 8 5 4 9 100 3 2 99 1
18 5 4 19 100 3 2 99 1
23 4 19 100 3 2 99 1
27 19 100 3 2 99 1
--> 19 100 30 2 99 1 /the 19 gets distributed on to the 30, but the 30 is only there if we include 4 5 8 10, 
100 49 2 99 1
149 2 199 1
151 199 1
199 152
,351
`long$()
`long$()
