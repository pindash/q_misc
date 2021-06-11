Let x be a table with 4 columns: sym,qty,id,p
sym is symbol
id a unique id per order
qty is signed, negative selling, positive buying
p is the limit price
x

{ 
	/get the sells and order them descending by price 
	 s:`p xdesc select from x where qty<0;
	/sort the sells by symbol, create a column called ps (price sell),
	/  and create column css (cummulative sell sizes)
	 s:update css:sums qty, ps:p by sym from s;
	/ update attribute on sym to be grouped for faster join, (symbols will be grouped together)
	 s:update `g#sym from s;
	/Repeate for buys but sort by ascending price instead 
	 b:`p xasc select from x where qty>0;
   	 b:update `g#sym from update csb:sums qty, pb:p by sym from b;

   /Here is the magic bit:
   /do an as of join on symbol (which will do a simple equality match)
   / as of on price joining the sell price to the nearest price less than or equal from the buys
   	 c:aj[`sym`p;s;b];
   /this works, because the sells are sorted in descending order based on price

   /now we find the sol matching orders by taking the min of cummulative buys vs cummulative sells
   / and sort descending on sol so that we can match the most orders 
   / finally sort ascending by symbol
   	 c:`sym xasc `sol xdesc update sol:abs[csb]&abs[css] by sym from c;
   /our result will have the maximum price we were willing to buy at and minmun we are willing to sell at
   / by and number of shares crossed	 
   	 res:select maxbuyP:first pb,minsellP:first ps, clearedShares:first sol by sym from c;
   / if there are no crossed shares, set null for maxbuyprice and minSellprice
	 res:update maxbuyP:0n, minsellP:0n from res where null clearedShares;
   / if the crossing price maxbuyP is greater than minSell, there are no cleared shares set 0
	 res:update clearedShares:0 from res where maxbuyP>minsellP;
   
   / select the ids where the orders crossed, 
   	/ that is where the cummulative buy/sells are less than the crossed shares 
    / (this works because cummalitive was based on ordering by price)
	 res:res lj select clearId:id by sym from ((b uj s) lj res) where abs[css^csb]<=(max;clearedShares) fby sym;
   	/ Find the shares that didn't cross where the cummulative was larger than cleared shares 
   	 res:res lj select unclearId:id by sym from ((s uj b) lj res) where abs[csb^css]>(max;clearedShares) fby sym;
    /Find the first id that only had a partial fill by taking the first of the uncleared orders
   	 res:res lj select partial: first over unclearId by sym from res;
   	/find the partial filled qty by summing all the cleared shares and finding the remaining shares
   	/ clearedShares are found by keying x on id and then selecting all ids that we found in clearId
   	 res:update 0^partialQty from res lj select partialQty:neg sum qty by sym from (`id xkey x)[select id:raze clearId from res];
   	 res