reset:{
  ot:update `u#id,`g#p from flip `id`q`p!(7h$();7h$();7h$());
  mt:([]id:7h$();sid:7h$();p:7h$();q:7h$();mID:7h$());
  orderbook:-1 0 1h!(ot;mt;ot);
  `P`I`MI`orderbook set' (10000;0;0;orderbook)}

m:{[n;o]slg:{7h$raze (x*asc k where (x*y)>=k:x*key z)#z};
  ms:{x where 1h$x`q}select id,sid:o`id,p,q:deltas(o`q)&sums q from c slg[s;o`p;group (c:n[neg s:o`s])`p];
  ms[`mID]:MI+til cnt:count ms;if[cnt;MI+::cnt;@[n;0h;,;ms];@[n;neg s;pj;neg 1!`id`q#ms]];
  if[o[`q]-:sum ms[`q];@[n;s;,;`s _ o]];ms[`mID]}

a:{I::x+i:I;flip `id`s`q`p!(i+til x;x?1 -1h;100*x?100;P+-5000+x?10001)};
os:a 10000;
\t:10 reset[];`orderbook m/:os

