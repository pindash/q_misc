/gale shapeley 
/nrmp
i:10000 /number of pairs
c:neg 1000 /ranked list per applicant , use 0N to do a full ranking
m:neg[i]?`8 /randomly chosen symbols
w:upper m
tm:m!((i#neg 1000)?\:w),'m /rankings m to w
tw:w!(i#(neg 1000))?\:m    /ranking w to m
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
