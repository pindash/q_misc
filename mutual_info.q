/sparse
sm:{([]row:where count each c;col:raze c;val:raze x@'c:where each x<>0)}
ms:{./[(1+max x)#0.;x:x[;`row`col];:;x`val]}

unibins:{[n;x]min[x]+(til[n])*(max[x]-min[x])%n}
hist2d:{[x;y;b]ms 0!select val:9h$count i by col:x,row:y from flip b bin' 9h$(x;y)}
/eg hist2d[x;y;`x`y!unibins[4] each (x;y)]

/hist n dimension
histdd:{[xs;b]?[flip b bin' (xs);();k!k:key[b];enlist[`c]!enlist (count;`i)]}

mutualinfo:{[x;y;b]
	t:0!histdd[9h$(x;y);`x`y!unibins[b] each (x;y)];
    lcm:log t[`c];nm:t[`c]%cs:sum[t`c];
    px:0^(exec sum c by x from t)til 1+max t[`x];
    py:0^(exec sum c by y from t)til 1+max t[`y];
    o:px[t[`x]] * py[t[`y]];
    lo:neg[log[o]]+log[sum px]+log[sum py];
    mi:(nm * lcm - log cs) + nm * lo;
    sum[mi]%log[2]
	}
