/simple
o:([]p:-3 1 -2 1 -2 1 -2 3 -10 -10 -11;q:1)
o:o,([]p:enlist 0;q:0)
gp:{[o;s]9h$@[0N*o`p;where s=signum o`p;:;abs o[`p] where (o[`q]>0)&s=signum o`p]}
s:0^gp[o;-1]
b:0w^gp[o;1]
{[b;s;x] 0|prev (maxs maxs[x+s]-b)|maxs s+ maxs x-b}[b;s]/[count[b]#0f]

/let's record state
f:{[o]
 gp:{[o;s]@[0N*o`p;where s=signum o`p;:;abs o[`p] where (o[`q]>0)&s=signum o`p]};
 o:([]p:enlist 0;q:0),o,([]p:enlist 0;q:0);s:0^gp[o;-1];b:0W^gp[o;1];
 kk:{(count[x]#())!x};smaxs:{k:key x;m:maxs v:value x;((k,'m?m)m?m)!m};
 sor:{?[vx<vy;key y;key x]!(vy:value y)|vx:value x};
 mp:{[b;s;x]0|{prev[key x]!prev value x}sor[smaxs smaxs[x+s]-b;smaxs smaxs[x-b]+s]};
 x:mp[b;s]/[kk count[b]#0];l:last key x;
 p:$[last x;#[-2*1+(sums neg sum o[`p] flip 0N 2#reverse l)?last x;l];7h$()];
 (last[x]=neg sum o[`p] p;p;last key x;value x;o`p)}

/test f
genO:{([]p:(x?-1 1)*1+x?20;q:1)}
all @[;0] each f each genO each 3+1000?100


/g update the trades we did
lam:{[o]([]p:enlist 0;q:0;t:0),o,([]p:enlist 0;q:0;t:0)}
g:{[o]
 gp:{[o;s]@[0N*o`p;where c;:;abs o[`p] where c:(o[`q]>0)&s=signum o`p]};
 s:0^gp[o;-1];b:0W^gp[o;1];
 kk:{(count[x]#())!x};smaxs:{k:key x;m:maxs v:value x;((k,'m?m)m?m)!m};
 sor:{?[vx<vy;key y;key x]!(vy:value y)|vx:value x};
 mp:{[b;s;x]0|{prev[key x]!prev value x}sor[smaxs smaxs[x+s]-b;smaxs smaxs[x-b]+s]};
 x:mp[b;s]/[kk count[b]#0];l:last key x;
 path:$[last x;#[-2*1+(sums neg sum o[`p] flip 0N 2#reverse l)?last x;l];7h$()];;
 update q:0|q-1,t:t+signum[p]*1 from o where i in path}
/test g
where 0<>{exec sum t from g over o:lam update t:0 from x} each o:genO each 1+10000?20 

/h add limits
h:{[hl;o]
   o:lam update t:0 from o;
   limiter:{[hl;x] update q:0 from x where hl<=abs sums t,signum[p]=signum sums t}[hl];
   gprime:(')[limiter;g];
   gprime over o}

o1:update q+count[i]?3,t:0 from genO 10
h[2;o1]





