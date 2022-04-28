/ 
accept takes tupple (account;seq;msgtype;data) seq is per account sequence number
long,long,symbol,dictionary
if accepted gets stamped with (g)lobal (s)equence number


msgtype order: data is
order is dictionary with keys:
sym,side,size,price
long,long,symbol,char,long,long (decimal * 10000)

order that gets submitted, recieves ack/nack
ack is (gseq,account,seq+1,oid), nack is null

msgtype cancel: data is oid
ack is (gseq,account,seq+1,oid), nack is (gseq,account,seq+1,null)

callbacks:
you can subscribe to callbacks following way:
(account;seq;`cb;channel)
channels:`fills`trades`bbo`top`depth
fills
\
show .z.i;








/simple orderbook only adds
M:1 -1h!(`bask`bids`bbid;`bbid`asks`bask);
reset:{[]
 P::10000;I::0;MI::0;ot:flip `id`q`p!(7h$();7h$();7h$());
 mt:([]id1:7h$();id2:7h$();p:7h$();q:7h$();mID:7h$());
 OB::`bbid`bask`bids`asks`matches!(-0W;0W;ot;ot;mt);};


/(b)ook, (o)rder
add:{[b;o]if[(</)(p:o`p;l:b M[s;0])*s:o`s; /?nomatch
  @'[b;1_M[s];(,;{x*z|x*y}s);(`s _ o;s*p)];:7h$()];
  match[b;o]};
/(b)ook, (o)rder
match:{[b;o]
 s:o`s; ms:select id1:o[`id],id2:id,p,q:deltas o[`q]&sums q from /find matches buy
 (select[<s*p] from b[M[neg s;1]] where (s*p)<s*o[`p],q>0) 
  where not prev o[`q]<sums q;
 MI::count[ms]+mi:MI;ms:update mID:mi+i from ms;@[b;`matches;,;ms];
 @[b;M[neg s;1];pj;`id xkey select id:id2,neg q from ms]; /adjust bids/asks
 @[b;M[s;0];:;exec s*min s*p from b[M[neg s;1]] where q>0]; /adjust bbo
 if[o[`q]-:exec sum q from ms;@'[b;1_M[s];(,;{x*z|x*y}s);(`s _ o;s*o`p)]];
 					/add unfilled qty to bids if not zero
 d:{delete from x where q=0};@'[b;`bids`asks;(d;d)]; /clean up delete all zero qty orders from table
 exec mID from ms};
/generate orders
reset[];
a:{I::x+i:I;flip `id`s`q`p!(i+til x;x?1 -1h;100*x?100;P+-5000+x?10001)};
os:a 1000000;
match:{[o;b]7h$()};
\t add'[`OB;os]

/o:`id`s`q`p!(999999;-1h;100000000000;0)

