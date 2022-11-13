init_deque:{`deque`head`tail set' (([]v:();l:`long$();r:`long$());0N;0N)}
place:{[v;l;r]i:count deque;
 `deque insert n:`v`l`r!(v;i^r^l;i^l^r);deque[n`r;`l]:i;deque[n`l;`r]:i;i}
push_front:{n:place[x;tail;head];`head set n;`tail set deque[n;`l];n}
push_back:{reverse_deque[];n:push_front[x];reverse_deque[];n}
/push_back:{n:place[x;tail;head];`tail set n;`head set deque[n;`r];n}
pop_front:{if[null i:head;:0#deque[;`v]];
	`head set deque[deque[i;`l];`r]:deque[i;`r];
	deque[deque[i;`r];`l]:deque[i;`l];
	deque[i;`l`r]:0N;`tail set deque[head;`l];`head set deque[tail;`r];
	deque[i;`v]}
pop_back:{reverse_deque[];b:pop_front[];reverse_deque[];b}
/dextrorotation
dextro:{`tail set head;`head set deque[head;`r]}
/laevorotation
laevo:{`head set tail;`tail set deque[tail;`l]}
/rotate
turn:{$[0<x;dextro/[x;::];laevo/[neg x;::]]}
print:{deque[;`v] {x where not null x} deque[;`r] scan head}
reverse_print:{deque[;`v] {x where not null x} deque[;`l] scan tail}
reverse_deque:{update l:r,r:l from `deque;h:head;`head set tail;`tail set h;}

/bulk append
push_backn:{h:(i:count[deque])^head;t:(-1+i+count x)^tail;
 n:`deque insert ([]v:x;l:t,-1+c;r:(c:1_i+til count x),h);
 if[null head;`head set first n;`tail set last n;:n];
 deque[tail;`r]:first n;`tail set deque[head;`l]:last n;n}
push_frontn:{reverse_deque[];n:push_backn[x];reverse_deque[];n}


/UNIT TESTS
init_deque[]
/()
push_back each `a`b`c
/`a`b`c
reverse_deque[];
/`c`b`a
reverse_deque[];
/`a`b`c
dextro[]
/`b`c`a
push_back `d
/`b`c`a`d
push_front `e
/`e`b`c`a`d
laevo[]
/`d`e`b`c`a
laevo/[2;::]
/`c`a`d`e`b
turn -3
/`d`e`b`c`a
turn 3
/`c`a`d`e`b
print[]



;
/aoc_2018_d9
/
init_game:{[n]init_deque[];`N set n;`elves set n#0;push_front[0]}
play:{[m]$[m mod 23;
	[turn[2];push_front m];
	[turn[-7];elves[m mod N]+:m+pop_front[]]];m+1}
init_game 428
play/[{x<=70825};1]
max elves
