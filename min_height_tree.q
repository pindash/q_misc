
edges:(`a`b;`b`c;`e`c;`d`e;`e`f;`e`h;`e`k;`f`g;`h`i;`h`j;`k`l;`l`m;`m`n;`n`o;`o`p;`p`r;`r`s)
nodes:distinct raze edges
leaves:where 1=count each group raze edges
parents:nodes except leaves
dfs:{[visted;e] if[0=count e;:(visted;e)];x:first visted; n:first (e i:first where any each e in x) except x;$[null n;(1 _ visted;e);(n,visted;e _: i)]}/
me:(til[count edges]!edges)
dftrav:{x where (>':) count each x }first each dfs scan (rand parents;me)
dfnodes:first cp:flip 2#'dftrav
far:first dftrav {x?max x}count each dftrav
longestpath:{x {x?max x} count each x }first each dfs scan (far;me)
minheigtnodes:{$[mod[c:count x;2];x c div 2;x -1 0+ c div 2]} longestpath




/Create Random Tree from Prufer sequence:
prufer2tree:{
    deg:@[count[g:til 2+count x]#0;x;+;1];
    ds:{[g;d;e]@[d;e,d[g]?0;-;1]}[g]\[deg;x];
    tree:(x;(enlist[deg],-1 _ ds)?\:0);
    tree,'reverse 2 1#where not last ds}

/the parent vector from an edge list is just
edges:flip prufer2tree 1+til 4
nodes:distinct raze edges:asc each edges
pv:@[count[nodes]#0;nodes?last flip edges;:;nodes?first flip edges]
/test if this converges and show node labels
nodes pv scan til count nodes




/other tree functions
pv:dfnodes ?last cp
levelup:{dfnodes pv dfnodes?x} 
dfnodes!count each distinct each flip levelup scan dfnodes
components:0!([cid:til count leaves]elems:enlist each leaves;ancestor:dfnodes pv dfnodes?leaves)
mergecomponents:{[x]
 t:update elems:(elems,'ancestor),levelup ancestor from x;
 cidm:exec raze elems by cid from t;
 merge:exec ancestor {z where x in y}[;;cid]/: elems from t;
 t:update elems:(elems,'raze each cidm merge) from t;
 delete from t where cid in raze merge}
mergecomponents components
