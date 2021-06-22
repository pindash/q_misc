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
f:{@[1 _ x;i where differ maxs y i:where first[y]>y;+;first x]}
max each 
f[10 8 5 4 9 100 3 2 99 1;10 8 5 4 9 100 3 2 99 1]
scan 
f scan {1 _ x} scan reverse a
x:10 8 5 4 9 100 3 2 99 1
y:8 5 4 9 100 3 2 99 1
x:9 19 100 3 2 99 1
x:y:9 100 3 2 99 1

x:23 4 9 100 3 2 99 1
y:5 4 9 100 3 2 99 1
f[x;y]

where differ maxs @[y;where h<y;:;0N]
