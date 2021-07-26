
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
