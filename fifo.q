/from sparse.q
sm:{([]row:where count each i;col:raze i;val:raze x@'i:where each x<>0)} /sparse from dense
fifo:{[buys;sells] deltas each deltas sums[buys] &\: sums[sells]}; /from q for mortals shock and awe 
orders:1 1 -2 1 -2 3 2 7 -8 /small test case
Buys:?[o>0;o;0] / 1 1 0 1 0 3 2 7 0
Sells:?[o<0;neg o;0] /0 0 2 0 2 0 0 0 8
fifo[Buys;Sells]
/
0 0 1 0 0 0 0 0 0
0 0 1 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
0 0 0 0 1 0 0 0 0
0 0 0 0 0 0 0 0 0
0 0 0 0 1 0 0 0 2
0 0 0 0 0 0 0 0 2
0 0 0 0 0 0 0 0 4
0 0 0 0 0 0 0 0 0
\
sm fifo[Buys;Sells]
/
row col val
-----------
0   2   1  
1   2   1  
3   4   1  
5   4   1  
5   8   2  
6   8   2  
7   8   4  
\
genOrders:{(1+x?10)*signum 0.5+neg x?1.0} / generates pseudo random orders of both sides of size x

n:{[o]b:?[o>0;o;0];s:?[o<0;abs o;0];sm fifo[b;s]} /naive version for testing. 
                                            /creates an index that matches buyIds with sellIds in an order series

/naive2 notice that we can use the indexes of the original list to make the problem 2 times smaller
/the space is still n^2 and the time will still go up proportionally
n2:{[o] 
 signed:abs o unindex:group signum o;
 update row:unindex[1]row,col:unindex[-1] col from sm fifo[signed 1;signed -1]}


/The next idea was to break the problem into pieces and solve parts and stitch them together
/make use of the faster n2 as the inside tight loop, only work on 500 orders at a time.
/this has worst case performance when you have many runs (ie only buys or sells for a period of time) 
fifoIterative:{[o]
 iterate:{[a;o]
  t:n2[o:a[1],o];
  if[0=count t;:a];
  p:0<sum o;
  c:exec sum val from t where ?[p;row;col]=max ?[p;row;col];
  k:li _ @[o;li:max t[`col`row p];(+;-) p;c];
  a[1]:?[((<;>)p)[k;0];k;0];
  a[2],:update row+a[0], col+a[0] from t;
  a[0]+:count[o]-count a 1;
  a};
 last iterate/[(0;();sm 1 1#0);0N 500#o]
 }
   
/
The previous iterative approach still takes n^2 space each iteration, but it is capped for most cases. 
 it now scales to millions of orders
\

/
We now try the standard approach, where we keep track of the two lists increment until the buys or sells run out

We use a few tricks:
1. we group the buys and sells using the signum --> this is signed
2. though our two lists are shorter, we keep track of each orders original index so we can allocate to the right order number
3. normally as we fold through we would call scan, 
    collect the first result from each then raze it together to get the iterative allocations.
    however, then we would incurr a huge memory overhead, so we are keeping that first part of the result on each iteration
    and keeping the rest of the intermediate result only from one call to the next this allows us to call 'over' instead. 
    to make it a little easier, we apend to the front of the array, this allows us to always index into element 0. But 
    forces us to reverse each list at the end
4. we use the test condition of whether the buy is greater than the sell, to appropriately increment the indexes into each
    of the buys and sells, we don't test for equality, so we sometimes allocate, 0, we drop these rows in the last step. 
5. each allocation is technically, the previous rows allocation, so we need to call next on the val (allocations)

with that preamble here is the code

there is a cool trick of wrapping a function into .[] so that we can pretend it's a function of one argument 
the function will unwrap the arguments into their positional place each time. kind of like pythons *args
\
traditionalFifo:{[o]
	signed:abs (o unindex:group signum o);
	k:(.[{[a;b;s]if[0=last[s]&last[b];:(a;b;s)];
	      l:a[;0];l[2]:$[c:b[l 0]<=s[l 1];b[l 0];s[l 1]];
	      ((l+(0 1 0;1 0 0)c),'a;@[b;l 0;-;l 2];@[s;l 1;-;l 2])}]);
	{delete from x where 0=0^val}
	 update row:unindex[1] row, col:unindex[-1] col, next val from  
	 flip `row`col`val!reverse each first k over (flip enlist 3#0;signed 1;signed -1)}


/
Amazingly, this did not fix the performance issues, 
it works, pretty well upto 10k orders, 
the problem is that we are copying the array each time we concatenate, 
eventually, this copy and concatenate and pass by value sematics destroy the performane. 

Our final version is a hacky fix, that simply preallocates an array, and passes everything by reference:
\
fastFifo:{[o]
  signed:abs (o unindex:group signum o);
   if[any 0=count each signed 1 -1;:([]row:();col:();val:())];
    k:(.[{[a;i;b;s]if[0=last[get s]&last[get b];:(a;i;b;s)];
         l:a[;i];l[2]:$[c:b[l 0]<=s[l 1];b[l 0];s[l 1]];
       (.[a;(til 3;i);:;l+(0 1 0;1 0 0)c];i+:1;@[b;l 0;-;l 2];@[s;l 1;-;l 2])}]);
   `.fifo.A set (3;count[o])#0;
   `.fifo.B set signed 1;
   `.fifo.S set signed -1;
   res:{delete from x where 0=0^val}
    update row:unindex[1] row, col:unindex[-1] col, next val from  
    flip `row`col`val!get first k over (`.fifo.A;0;`.fifo.B;`.fifo.S);
    delete A,B,S from `.fifo;
   res}

/We now right a small test harness to print the table 
fs:`n`n2`fifoIterative`traditionalFifo`fastFifo /the functions we want to test
I:1000*1 2 5 10 20 50  /number elements in each test
orders:{(`$"o",string[count x]) set x} each genOrders each I /create globals to test with
timeIt:{(`f`input`inputSize!(x;y;count get y)),`time`space!system "ts ",string [x]," ",string y} /super hacky timer function

/start this and walk away for 5  minutes
t:raze fs timeIt\:/: orders
/
f               input  inputSize time   space      
---------------------------------------------------
n               o1000  1000      17     16433568   
n2              o1000  1000      2      7897664    
fifoIterative   o1000  1000      1      2015520    
traditionalFifo o1000  1000      6      99616      
fastFifo        o1000  1000      11     121984     
n               o2000  2000      67     65634720   
n2              o2000  2000      7      31883840   
fifoIterative   o2000  2000      2      2161488    
traditionalFifo o2000  2000      13     197920     
fastFifo        o2000  2000      15     242592     
n               o5000  5000      388    655753632  
n2              o5000  5000      67     166396480  
fifoIterative   o5000  5000      6      2403216    
traditionalFifo o5000  5000      55     656672     
fastFifo        o5000  5000      40     856992     
n               o10000 10000     1682   2622226848 
n2              o10000 10000     224    651952704  
fifoIterative   o10000 10000     17     2633232    
traditionalFifo o10000 10000     191    1312032    
fastFifo        o10000 10000     78     1713056    
n               o20000 20000     22629  10487333280
n2              o20000 20000     2430   2600206912 
fifoIterative   o20000 20000     45     5277456    
traditionalFifo o20000 20000     701    2622752    
fastFifo        o20000 20000     185    3441568    
n               o50000 50000     214900 52431946144
n2              o50000 50000     50527  13098287680
fifoIterative   o50000 50000     171    4215056    
traditionalFifo o50000 50000     4220   5244192    
fastFifo        o50000 50000     493    6882208    
\
/
you can view the plots 
https://github.com/pindash/q_misc/blob/master/graphs/fifogeneral_time.png
https://github.com/pindash/q_misc/blob/master/graphs/fifogeneral_space.png

it's pretty clear that n,n2, and traditionalFifo don't scale well,
there is an interesting quirk in the memory usage of fifoIterative we explore that further
it also looks like fifoIterative is faster than fastFifo
\

/
We can easily see that only fastFifo and fifoIterative are worth testing past 10k orders
graphs of the time and space usage for various input sizes can be seen here:
https://github.com/pindash/q_misc/blob/master/graphs/fastVersion_space_time_exponential_spacing.png
inputSize f             time  space    
---------------------------------------
10000     fifoIterative 17    2608656  
50000     fastFifo      543   6882208  
100000    fifoIterative 231   8703248  
140000    fastFifo      1653  23200672 
190000    fifoIterative 470   14185792 
230000    fastFifo      2631  27526048 
280000    fifoIterative 1470  16057616 
320000    fastFifo      3581  54789024 
370000    fifoIterative 1329  28292416 
410000    fastFifo      4919  55051168 
460000    fifoIterative 2172  29050176 
500000    fastFifo      5803  55051168 
550000    fifoIterative 3418  29840704 
590000    fastFifo      6891  109577120
640000    fifoIterative 4767  55678272 
680000    fastFifo      8338  109577120
730000    fifoIterative 5086  56415552 
770000    fastFifo      9052  110101408
820000    fifoIterative 5863  57238848 
860000    fastFifo      9833  110101408
910000    fifoIterative 5237  57890112 
950000    fastFifo      11691 110101408
1000000   fifoIterative 9906  58713408 
\
