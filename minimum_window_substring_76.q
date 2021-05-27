/https://leetcode.com/problems/minimum-window-substring/
s:"ABDOBECODEBANCA" 
t:"ABC"
/s:100000?.Q.A
/t:-10?.Q.A
/dynamic programing approach
f:{[s;t]
  f:.[{[s;t;b;i;j]$[b:all t in s i _ til j;(b;i+1;j);(b;i;count[s]&j+1)]}[s;t]];
  r:1 _ r {x?min x where 0<>x}{x*x+z-y} . flip r:f scan (0b;0;0);
  r,1 + last deltas r}

ml:{l:min i:1+abs (-/)flip x;(l;x i?l)} /minlength finds min length and indexes

/first attempt of jumping around lattice
g:{[s;t]1 _' .[{[x;y;z]x:asc x;c:x[0;0];x[0]:1 _ x[0];(x;c;max min each 1 _ x)}] scan (value t#group s;0N;0W)}

/naively do possible lattice search
h:{[s;t]raze[k[t]],'raze {max x {0W^y first where y>x}\:/: y}'[k[t];value each t _\: k:t#group s]}

/naively do possible lattice search (parallel)
hp:{[s;t]raze[k[t]],'raze {[k;t]max k[t] {0W^y first where y>x}\:/: value t _ k}[k:t#group s] peach t}

/eliminate search space as we go
h1:{[s;t]
 trv:{[x;y;z]k:0^first[y];i:first where (x:k _ x)>z;(i+k;0W^x i)};
 raze[k t],'raze {[f;x;y]max flip (last'')(f'[y])\[0;x]}[trv]'[k t;value each t _\: k:t#group s]}
 
 
/shorter and parallel
l3:{[s;t]min(-/)({max 0W^x@'(first where ::)each x>y}[k] peach c;c:raze k:value t#group s)}
