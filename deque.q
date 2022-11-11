init_deque:{`deque`head`tail set' (([]v:();l:`long$();r:`long$());0N;0N)}
place:{[v;l;r]i:count deque;
 `deque insert n:`v`l`r!(v;i^r^l;i^l^r);deque[n`r;`l]:i;deque[n`l;`r]:i;i}
push_front:{n:place[x;tail;head];`head set n;`tail set deque[n;`l];n}
push_back:{n:place[x;tail;head];`tail set n;`head set deque[n;`r];n}

pop_front:{if[null i:head;:0#deque[;`v]];
	`head set deque[deque[i;`l];`r]:deque[i;`r];
	deque[deque[i;`r];`l]:deque[i;`l];
	deque[i;`l`r]:0N;`tail set deque[head;`l];`head set deque[tail;`r];
	deque[i;`v]}

/dextrorotation
dextro:{`tail set head;`head set deque[head;`r]}
/laevorotation
laevo:{`head set tail;`tail set deque[tail;`l]}
/rotate
turn:{$[0<x;dextro/[x;::];laevo/[neg x;::]]}
print:{deque[;`v] {x where not null x} deque[;`r] scan head}
reverse_print:{deque[;`v] {x where not null x} deque[;`l] scan tail}
reverse_deque:{update l:r,r:l from `deque;h:head;`head set tail;`tail set h;}



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


init_deque[];push_back each `a`b`c`d
pop_front[]
print[]
deque[;`v] {x where not null x} deque[;`l] scan head
push_back `a
head
`symbol$()



;


init_game:{[n]init_deque[];`N set n;`elves set n#0;0}
play:{$[m mod 23;]}

