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
                             
/The next idea was to break the problem into pieces and solve parts and stitch them together
fifoUsingIterative:{[o]
	iterative:{[a;o]
    if[0=count o;:a];
    if[a~();a:(0;0;();([row:();col:()]val:()))];
    o:a[2],o;
    b:?[o>0;o;0];
    s:?[o<0;neg o;0];
    rp:1+r:last where differ signum sums o;
    a[3],:update row+a[0], col+a[1] from sm fifo[b;s];
    a[2]:((sums o) r),rp _ o;
    a[0]+:count[o]-c:count[a[2]];
    a[1]+:count[o]-c;
    a};
    0!last iterative/[();0N 1000#o]
   }
   
/
The previous iterative approach still takes n^2 space each iteration, 
 it is also slow and doesn't scale to hundreds of thousands of orders
\

/
We now try the standard approach, where we keep track of the two lists increment until the buys or sells run out

We use a few tricks:
1. we group the buys and sells using the signum --> this is signed
2. though our two lists are shorter, we keep track of each orders original index so we can allocate to the right order number
3. normally as we fold through we would call scan, 
    collect the first result from each then raze it together to get the iterative allocations.
    however, then we would incurr a huge memory overhead, so we are keeping that first part of the result on each iteration
    and keeping the rest of the intermediat result only from one call to the nex this allows us to call 'over' instead. 
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

/1000 orders
OO:genOrders 1000
\ts n[OO]
13 16433568
\ts fifoUsingIterative[OO]
13 16442192
\ts traditionalFifo[OO]
8 83232
\ts fastFifo[OO]
9 108448

/10k orders
OOk:genOrders 10000
\ts n[OOk]
1028 2622226848
\ts fifoUsingIterative[OOk]
418  657982448
\ts traditionalFifo[OOk]
115  1312032
\ts fastFifo[OOk]
41   1713056

/100k orders
OO100k:genOrders 10000
\ts n[OO100k]
148332 209721491872
\ts fifoUsingIterative[OO100k]
did not complete (I suspect, there is some tuning that can be applied)
\ts traditionalFifo[OO100k]
15917  10487072
\ts fastFifo[OO100k]
318    13763488

only fastFifo scales linearly with the input
