sa:{[n;c;s;t]$[rand[1.0]<exp[neg[c[p:n s]- c s]%t];p;s]}
/toy example minimize (x+1)^2
c:{x*x:x+1}
n:{x+rand[2.0]-1}

/alternative take smaller steps as you get closer to the min
/n:{x+rand[2*a]-a:0.001+abs c x}

sa[n;c]/[5.0;100%1+til 1000000]

/rewrite sa to allow different cooling schedules
sa:{[n;c;d;t;s]f:{[n;c;d;t;s]t:d t;$[rand[1.]<exp neg[c[p:n s]-c s]%t;(t;p);(t;s)]};
  last f[n;c;d]//[(t;s)]}
sa[n;c;{1e-50|x*0.9999};1000.0;5.0]

/TSA problem:
/create a Traveling Salesman example where we know the solution
/choose points on a circle
pnts:flip (cos;sin) @\: {til[x]%x}[50]*2*pi:acos -1
n:{@[x;p;:;x reverse p:-2?count x]} /neighbors are two swapped points
dist2:{y wsum y-:x} /distance squared
/cost is sum of the distances plus getting back to the start, we want a loop
c:{p:pnts x;sum sqrt dist2[last p;first p],dist2':[first p;1 _ p]}
c til count pnts / min distance is simply 2*PI
c sa[n;c;{1e-50|x*0.9999};10000.0;0N?count pnts]
