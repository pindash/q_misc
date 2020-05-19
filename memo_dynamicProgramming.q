.memo.M:{[f] .memo.f[f]:()!(); {[f;x]$[x in key .memo.f[f];.memo.f[f;x];:.memo.f[f;x]:f[x]]}[f]}
.memo.f:()!()
.memo.MM:{[f] 
        c:count[value[f] 1];
        .memo.f[f]:enlist[()]!enlist ();
        memof:{[f;x]$[x in key .memo.f[f];.memo.f[f;x];:.memo.f[f;x]:f . x]}[f];
        {'[x;eval(enlist),y#(value (;))(),1]}[memof;c]}/multivalent version
.memo.MMwMemLimit:{[f;n] 
        c:count[value[f] 1];
        .memo.f[f]:enlist[()]!enlist ();
        memof:{[n;f;x]$[x in key .memo.f[f];
             [.memo.f[f]:(enlist[x] _ .memo.f[f]),enlist[x]#.memo.f[f];:.memo.f[f;x]];
             [.memo.f[f]:(n=count .memo.f[f])_ .memo.f[f];:.memo.f[f;x]:f . x]]}[n;f];
        {'[x;eval(enlist),y#(value (;))(),1]}[memof;c]} /version that limits number of memoized items


fib:.memo.M 
\t (fib:{$[0=x;1;x=1;1;fib[x-1]+fib[x-2]]}) 30
\t (fib:.memo.M {$[0=x;1;x=1;1;fib[x-1]+fib[x-2]]}) 30
\t last 30 {x,sum -2#x}/ 1 1

/
-----
dynamic programming -- shortest path between two vertices
-----
\

cities:update id:i from ([]city:`NewYork`Columbus`Nashville`Louisville`KansasCity`Omaha`Dallas`Denver`SanAntonio`LosAngeles)
graph:([]id:0 0 0 1 1 1 2 2 2 3 3 3 4 4 5 5 6 6 7 8;
	id2:1 2 3 4 5 6 4 5 6 4 5 6 7 8 7 8 7 8 9 9;
	d:550 900 770 680 790 1050 580 760 660 510 700 830 610 790 540 940 790 270 1030 1390)

pDesc:(graph lj `id xkey cities) lj `id2 xkey `city2`id2 xcol cities

bf:{[graph;s;e;state] 
 if[state~();state:([]id:s;t:0;path:enlist(1#s))];
 arrived:select from state where id=e;
 state:delete from state where id=e;
 arrived,select id:id2, t:t+d, path:(path,'id2)
  from ej[`id;state;graph]
  where not id2 in' path,  id<>e
 }
`t xasc bf[graph;0;8] over ()

1#`t xasc bf[graph;8;9;] over ()
minPath:{[graph;state;arrived]
 0!select min t, path:path t?min t by id2 from arrived,
   select id2:id, t:t+d, path:(id,'path) 
 	 from ej[`id2;state;graph] where not id in' path
 }

dp:{[graph;s;e;state]
	if[state~();state:([]id2:e;t:0;path:enlist(1#e))];
	if[(1=count state) & s=first state[`id2];:state];
	arrived:select from state where id2=s;
	minPath[delete from graph where id2=s;state;arrived]
  }
f:
dp[graph;0;7;] over ()
state:
f f f f ()

genGraph:{[n;c]
 nodes:til n;
 delete from (`id`id2 xasc 
  0!((neg n*c)?([]id:nodes) cross ([]id2:nodes))
  !
     ([]d:(n*c)?1000)) where id=id2
 }
g1:genGraph[n:100;10]
\t 
`t xasc bf[g1;0;n-1;] over ()
\t 
dp[g1;0;n-1;] over ()




/words retrevied from https://raw.githubusercontent.com/dwyl/english-words/master/words.txt
words:read0 `:/data01/home/dashevsp/projects/workspace/words.txt
/remove words with silly characters and make all letters lowercase
words:trim lower words 
clean:words where all peach (words) in .Q.a
freq:{asc[key x]#x:count each group x}
res:(.Q.a!count[.Q.a]#0)+/freq peach clean
res~freq raze clean
ngram:{trim flip til[x]xprev\:y}
freq raze ngram[2] peach clean





minPath[g2;state]
graph,`id`id2`d!(0 9 2880)
g2:(graph,`id`id2`d!(10 9 2820)),`id`id2`d!(0 10 51)
returnMin:{[graph;e;state]
	if[state~();state:([]id:e;t:0;path:enlist(1#s))];
	select from graph where id2=e}

f:{count[x](x cross)/x}
\t f til 7


a(n) = product{k=0..log_2(n), 3^b(n, k)},
 b(n, k)=coefficient of 2^k in binary expansion of n(offset 0). - Paul D. Hanna

2 xlog til 6
a:{[n] $[n=0;0;n=1;1;n mod 2;a[ceiling 7%2];3*a[n div 2]]}
a 2

3a(n/2) a((n+1)/2)

a(0) = 0, a(2^i) = 1; otherwise if n = 2^i + j with 0 < j < 2^i, a(n) = a(j) + 1.
a:{$[x=0;0;x=1;1;x mod 2;a[ceiling x%2]+1;a[x div 2]]}
\t a each til 10000
\c 200 2000
key `
.o
 ceiling 7%2

 7h$(xlog[2;] 1+til 9) mod 2
(3#0 1)+0 1

flip 3 vs where (1=sum 2=p)*
where (1=sum 1=p)*1=sum 0=p:3 vs til 7h$3 xexp 3
perm:{ til x=p:x vs til 7h$x xexp x}
prd 
perm:{flip x vs where prd sum each til[x] =\:x vs til 7h$x xexp x}



a:7h$.5*a+flip a:10 10#@[100#0;6?100;:;1]
distinct raze where each a 1 5 6
where each a where a 1

findAllConnected:{[i;m]
neighbors: where m[i]; /find the initial list of neighbors
f:{distinct raze x,where each y x}[;m]; /create the function where second argument is fixed to be the adjacency matrix.
f over neighbors} 
distinct asc each findAllConnected[;a] each til count a



 findAllConnected:{[i;b] 
   cur:where b[i];
   f:{n:raze where each y .[_;x];
   	  x[0]:count x[1];x[1]:distinct x[1],n;
   	  x}[;b];
   last f over (0;cur)}
/large sparse matrix to test with
c:7h$.5*c+flip c:1000 1000#@[1000000#0;1000?1000000;:;1]

connected:
\t distinct asc each findAllConnectedFast[;c] each til count c
islands:(til count a) except raze connected /All the islands
count each connected /size of the components




findAllConnectedFast:{[i;m]
   neighbors: where m[i];
   f:{n:raze where each y .[_;x]; 
             x[0]:count x[1];x[1]:distinct x[1],n;
             x}[;m];
   last f over (0;neighbors)}

 findAllConnectedFast[1;a]



points:til count c
allComponents:{[m]
	points:til count m;
	connected:();
	while[count points;
	i:first points;
	connected,:enlist `s#distinct asc i,findAllConnectedFast[i;m]; /add point in case it is island
	points:points except raze connected];
	connected}
\t allComponents c

allComponents:{[connected;m]
 if[not count points:(til count m) except raze connected;:connected];
 i:first points;
	(connected,enlist`s#distinct asc i,findAllConnectedFast[i;m])}

\t allComponents[;c] over ()
allComponents:{[m]
	points:til count m;
	connected:();
	while[count points;
	i:first points;
	connected,:enlist n:`s#n:distinct asc i,findAllConnectedFast[i;m]; 
	points:points except n];
	connected}





words:distinct words iasc count each words:(10000#1+til 20)?\:.Q.a
t:([]w:words;c:count each words)
m:select w by c from t
a:raze value m 2
b:raze value m 3


allDrops:{where each (til x) rotate\: 0b,(x-1)#1b}
drops:n!allDrops'[n:1+til 20]
isOneOff:{[s;l;d]any s ~/:l d count[l]}
iof:isOneOff[;;drops]/:\:
l:exec w from m where c<6
index:('[;]) over (?[t[`w]];@[l[2]];{where each x};iof)
index[l[1];l[2]]
index'[l[til -1+count l];l[1+til -1+count l]]




text:("(a,b)";"(a,c)";"(b,c)";"(d,e)";"(c,e)")
text:read0 `:nodes
t:flip `node1`node2!flip `$ "," vs' ssr[;"[()]";""] each text 

exec node2 from t where node1=`a
{distinct x,exec node2 from t where node1 in x} over `a


longestChain:{[words]
	hwords:distinct words iasc count each words;
	t:([]wsym:`u#`$hwords;w:hwords;c:count each hwords);
	allDrops:{where each (til x) rotate\: 0b,(x-1)#1b};
	drops:n!allDrops'[n:1+til max t[`c]];
	sparseRes:ungroup `col xkey update col:i, row:t[`wsym]?`$(w@'drops c) from t;
  sparseRes:delete from sparseRes where row=count t;
  max {count select distinct c from x} each t allComponentsSparse sparseRes}
first t allComponentsSparse sparseRes
select count distinct c from first t allComponentsSparse sparseRes

findConnectedSparse:{[j;m]
	neighbors: exec col from m where row in j;
	f:{n:exec col from y where row in .[_;x]; /new neighbors
  	x[0]:count x[1];x[1]:distinct x[1],n; /update the two pieces of x
 	x}[;m]; /project this function on the matrix
	last f over (0; neighbors)};

allComponentsSparse:{[m]
	points:til max m[`row];
	connected:();
	while[count points;
	i:first points;
	connected,:enlist n:`s#n:distinct asc i,findConnectedSparse[i;m]; /add point in case it is island
	points:points except n];
	connected}
q
words:distinct (10000#1+til 20)?\:.Q.a
\t longestChain words
\t longestChainFast words
count words

\t hwords:distinct words iasc count each words
\t t:([]wsym:`u#`$hwords;w:hwords;c:count each hwords);
allDrops:{where each (til x) rotate\: 0b,(x-1)#1b}
drops:n!allDrops'[n:1+til max t[`c]];
drops:n!allDrops each n:exec distinct c from t
\t sparseRes:ungroup `col xkey update col:i, row:t[`wsym]?`$(w@'drops c) from t
\t sparseRes:delete from sparseRes where row=count t;
max {count select distinct c from x} each t allComponentsSparse sparseRes
select by c from update d:(w)@'drops c from t
`row xasc select row, col from sparseRes
q:select col by row from sparseRes
select by c from 
sparseRes:
ungroup `col xkey update col:i, row:t[`wsym]?`$(w@'drops c) from t
exec row:col from q where row in 
q select row:raze col from raze q exec row:col from q where row=0

{ $[count x[`cur]:select row:raze col from y x[`cur];
		[x[`depth]+:1;x[`visited],:x[`cur];:x]
		;:x]}[;q] over `depth`visited`cur!(0;([]row:());0)
n:update visited:count[n]#() from n:([]depth:0;cur:exec row from q)
f:{ $[count x[`cur]:select row:raze col from y x[`cur];
		[x[`depth]+:1;x[`visited],:exec row from x[`cur];:x]
		;:x]}[;q]

longestChainFast:{[words]
	hwords:distinct words iasc count each words;
	t:([]wsym:`u#`$hwords;w:hwords;c:count each hwords);
	allDrops:{where each (til x) rotate\: 0b,(x-1)#1b};
	drops:n!allDrops'[n:1+til max t[`c]];
	sparseRes:ungroup `col xkey update col:i, row:t[`wsym]?`$(w@'drops c) from t;
  sparseRes:delete from sparseRes where row=count t;
  q:select col by row from sparseRes;
  dive:{ $[count x[`cur]:select row:raze col from y x[`cur];
		[x[`depth]+:1;x[`visited],:exec row from x[`cur];:x]
		;:x]}[;q];
	n:update visited:count[n]#() from n:([]depth:0;cur:exec row from q);
	exec max depth from (dive/)each n}
dive over first n
q	indexTable:([]row:0 1)
q select row:raze col from q ([]row:0 1)



 sparseRes:delete from sparseRes where row=count t

\t longestChainFast words


exec max depth from (f/)each n


`depth`visited`cur!(0;();0)

sparseRes:delete from sparseRes where row=count t;


w:("a";"ab";"abc";"abdc"; "babdc";"dd"; "ded")
longestChainFast w



longestChainFast:{[words]
	hwords:distinct words iasc count each words;
	t:([]wsym:`u#`$hwords;w:hwords;c:count each hwords);
	allDrops:{where each (til x) rotate\: 0b,(x-1)#1b};
	drops:n!allDrops'[n:1+til max t[`c]];
	sparseRes:ungroup `col xkey update col:i, row:t[`wsym]?`$(w@'drops c) from t;
  sparseRes:delete from sparseRes where row=count t;
  q:select col by row from sparseRes;
  depthFirst:{ $[count x[`cur]:select row:raze col from y x[`cur];
		[x[`depth]+:1;x[`visited],:exec row from x[`cur];:x]
		;:x]}[;q];
	n:exec row from q;
	results:([]depth:();cur:();visited:());
	while [count n;
		j:`depth`cur`visited!(0;first n;());
		results,:depthFirst over j;
		n:n except j[`cur],exec raze visited from results];
	exec max depth from results}



/Old version too many edge conditions to work correctly
flatten:{[n]
    f:.[{[d;g;k]
        $[ 0 ~ count g;   :(d;g;k) 
           ;0 ~count k;   :(d;g;enlist[`])
           ;98h ~ type g;   :(d;raze g;k)
           ;(99h ~ type g); :(@[d;key g;:;key[g]^count[key g]#k];value g;{raze value[x]#'key[x]}count each g)
           ;any b:-11h = type each g; (@[d;g i;:;(g i)^key[group[k]]i];dropAtIndex[g;i];dropbyIndex[k;i:where b]) 
           ;0h ~ type g; :(d; {$[0h=type x;@[raze;x;x];x]} over g;k)
           ;11h ~ type g; :(@[d;g;:;g^k];();k)
         ;(d;g;k)]
        }];
  first f over (()!();n;())
 }


([]animal:`dog`cat`dolphin`hawk`dove`penguin`python`lizzard;weight:100 50 1000 30 5 125 100 25)






/EGYPTIAN DIVISION with Remainder

{last (0;y){$[x[1]>=y;(1;x[1]-y);(0;x[1])]}/reverse first flip (.[{($[y>=x;x+x;x];y)}]\) (x;y)}[6;10]




Faster Version of As of Join by joining symbols and peaching
aj[`s`n;`s xasc t1;`s xasc t2]
t1:([]s:n?`4;n:n?n;v:n?1.0)
t2:([]s:n?`4;n:n?n;v:n?1.0)
ff:{[k;t1;t2]
 n:last k;
 k:-1 _ k;
 t2s:(k xgroup t2);
 t1s:(k xgroup t1);
 f2d:{[f;x](f (::)x') peach til count x 0 }; 




