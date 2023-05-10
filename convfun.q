conv2d:{[k;m]shape:(count;count first::)@\:;
 ks:shape k;mt:(cross/)`j`k{x xcol([]til y)}'ms:shape m;
 kt:([]j:neg[ks[0]div 2]+til ks 0) cross ([]k:neg[ks[1]div 2]+til ks 1);
 trans:(?;(&;(within;`j;0,-1+ms 0);(within;`k;0,-1+ms 1));(raze[m];(sv;ms;(enlist;`j;`k)));0);
 ms#raze[k] wsum ?[;();();trans] peach kt+\:flip mt}
imin:{x?min x}
shape:-1 _ count each first\
sobel:{[m]shape:(count;count first::)@\:;kt:([]j:-1 0 1) cross ([]k:-1 0 1);
 mt:(cross/)`j`k{x xcol([]til y)}'ms:shape m;s:3 3#1 0 -1 2 0 -2 1 0 -1;
 trans:(?;(&;(within;`j;0,-1+ms 0);(within;`k;0,-1+ms 1));(raze[m];(sv;ms;(enlist;`j;`k)));0);
 v:?[;();();trans] peach kt+\:flip mt;sx:raze[s] wsum v;sy:raze[flip s] wsum v;
 ms#sqrt (sx*sx)+sy*sy}
sobel3d:{[m]s:3 3#1 0 -1 2 0 -2 1 0 -1;kt:([]j:-1 0 1) cross ([]k:-1 0 1);
 mt:(cross/)`j`k{x xcol([]til y)}'ms:1 _ shape m;m:raze each m;
 trans:(?;(&;(within;`j;0,-1+ms 0);(within;`k;0,-1+ms 1));(sv;ms;(enlist;`j;`k));0N);
 i:?[;();();trans]peach kt+\:flip mt;sx:raze[s]wsum/:v:0^m@\:i;sy:raze[flip s]wsum/:v;
 ms#sum sqrt (sx*sx)+sy*sy}
minseam:{reverse imin[first r] {x+-1 0 1 imin y x+-1 0 1}\r:reverse {y+min 0W^1 0 -1 xprev\:x}\[x]}
getseam:minseam sobel::
getseam3d:minseam sobel3d::
showseam:{x {@[x;y;:;0xff]}' minseam sobel x}
conv9:{raze each count[first x]#/:/:raze 2(1 0 -1 xprev/:\:)/x}
sob:{shape[y]#sqrt sum{x*x}raze'[(x;flip x)]wsum\:conv9 y}[s]



removeseam:{(m@'til[count first m]except/:s;last[x],enlist s:minseam sob m:first x)}
e:@[;19] flip last 30 removeseam/(im;())

(@'[;til 30]sums 6h$e<=\:e;til[30]#'e</:e;e)

{(x[0] except y;x[1],x[0]?y)}\[(til 10;());8 1 9 5 4]
0 1 2 3 4 5 6 7 9 ,8       
0 2 3 4 5 6 7 9   8 1      
0 2 3 4 5 6 7     8 1 7    
0 2 3 4 6 7       8 1 7 4  
0 2 3 6 7         8 1 7 4 3

{x<='til[count x]#\:x}e

({y except x}':) enlist[til 10],{x til[count x] except y}\[til 10;8 1 7 3]

e:8 1 7 3
f:{-1+@'[;til count x]7h$sums x<=\:x}
g:{{x,y+y in x} over x+f x}
g 8 1 7 4 3


