/gale shapeley 
/nrmp
i:10000 /number of pairs
c:neg 1000 /ranked list per applicant , use 0N to do a full ranking
m:neg[i]?`8 /randomly chosen symbols
w:upper m
tm:m!(#[i;c]?\:w),'m /rankings m to w
tw:w!#[i;c]?\:m    /ranking w to m
tw,:(m!0N 1#m)             /sentinal unmatched matches itself
t:1!([]w:w,m;m:`;s:0W)     /pairing table
iifin:{$[count[x]>c:x?y;c;0W]};  /find(?) with cost equal to infinity if not found
f:{[t]
 if[null cm:first key[tm] except (0!t)`m;:t];
 im:first where t[([]w:k);`s]>s:tw[k:tm cm]iifin\: cm;
 t upsert (k im;cm;s im)}
pairs:f over t


/alternatives to implement
/http://dcs.gla.ac.uk/~pat/jchoco/roommates/papers/Comp_sdarticle.pdf
/Knuth book on the topic Stable-Marriage
/https://www-cs-faculty.stanford.edu/~knuth/mariages-stables.pdf
/https://www.amazon.com/Stable-Marriage-Relation-Combinatorial-Problems/dp/0821806033


/vectorized version
setup:{[i]
 c:0N;m:neg[i]?`4;w:upper m;
 dm:m!(#[i;c]?\:w),'m;
 dw:w!#[i;c]?\:m;
 dw,:(m!0N 1#m);          
 t:1!([]w:w,m;m:`;s:0W);
 tm:{([]m:key x;w:value x;rm:(til count ::)each value x)} dm;
 tw:{([]w:key x; o:value x)} dw;
 tmtt:select m,w,rm,r:o iifin' m from (ungroup tm) lj 1!tw;
 `dm`dw`t`rd set' (dm;dw;t;tmtt)};
imin:{x?min x};iifin:{$[count[x]>c:x?y;c;0W]};  
f2:{[data;t]
 p:select n:m imin r, min r by w from data where not m in (0!t)`m, rm=1+seen;
 update seen+1 from data where not m in (0!t)`m;
 t upsert select w,m:n, s:r from (p lj t) where r<s};
setup 100;
\t f2[update seen:-1 from `rd]/[{count key[dm] except (0!x)`m};t]
