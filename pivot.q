
.utils.pivot2:{[t;k;p;v; agg]
    / controls new columns names
     f:{[v;P]`${raze "_" sv x} each string raze P[;0],'/:v,/:\:P[;1]};
     .tmp.f:f;
     v:(),v; k:(),k; p:(),p; / make sure args are lists
     G:group flip k!(t:.Q.v t)k;
     $[p~enlist[`]; F: group flip enlist[`total]!enlist count[t]#`total;
     F:group flip p!t p];

     A: agg;
     $[agg ~ sums;    agg: sum;
       agg ~ prds;    agg: prd;
       agg ~ deltas;  agg: sum;
       agg];
     V: raze
      {[agg; i;j;k;x;y]
       a:count[x]#x 0N;
       a[y]:x y;
       b:count[x]#0b;
       b[y]:1b;
       c:a i;
       c[k]:agg'[a[j]@'where'[b j]];
       c}[agg; I[;0];I J;J:where 1<>count'[I:value G]]/:\:[t v;value F];
     if[not A ~ agg; V: A each V];
    key[G]!flip(C:f[v]P:flip value flip key F)! V
  }
til 10
.utils.pivot:{[t]
 u:`$string asc distinct last f:flip key t;
 pf:{x#(`$string y)!z};
 p:?[t;();g!g:-1_ k;(pf;`u;last k:key f;last key flip value t)];
 p}
.utils.unpivot:{[s](count[o]#key[s]),'o:ungroup {([] k: key x; v: value x)} flip value s}
