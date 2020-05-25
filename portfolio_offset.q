/REFERENCE
This code doesn't work (just for reference)

reconstructedStaticOffset:{ [dt;offsetDt;hldPeriod;pos;npriceClean;trdDates]  
    / calc pnl using positions on a ref date
    
    posDt:$[offsetDt<2001.01.01;first trdDates[(trdDates?dt)+offsetDt];offsetDt];
    endDt:first trdDates[(trdDates?dt)+(hldPeriod-1)];
    `btzDate set $[null btzDate;first value first select max date from btz;btzDate];
    if[(posDt=0n)|(endDt=0n);:0n];
    t1:( `date`sym xkey `sym xcol (select from npriceClean where date within(dt;endDt), not Exchange=`PINK)) 
     lj 
     (`sym`date xcol select avg ProductionBeta by sym,`date$date  from btz where date within(min dt,btzDate;endDt))
     lj (`sym xkey select sum shares by sym from pos where date = posDt,account in `BOXP`LBXP`OBHP`LBHP`NMLP`NMOP);
    t2:update static:sum_prevpnlmarklast*shares*c_todayretadj,
	       staticHedged:sum_prevpnlmarklast*shares*c_todayretadjhedged,
	       staticETFtot:sum_prevpnlmarklast*shares*etf_tot_return, 
	       staticETFfactor:sum_prevpnlmarklast*shares*etf_factor_return,
	       staticETFspec:sum_prevpnlmarklast*shares*etf_spec_return,
	       offsetDt:offsetDt,hldPeriod:hldPeriod,notional:sum_prevpnlmarklast*shares  from t1;
   /t2:`date xkey update static:CloseConsolidated*shares*TodaysReturn from t1;
   / t2v:update offsetDt:offsetDt,hldPeriod:hldPeriod from t2;

   t3:select cumStatic:sum static,cumStaticHedged:sum staticHedged,
      cumStaticETFtot:sum staticETFtot, cumStaticETFfactor:sum staticETFfactor, cumStaticETFspec:sum staticETFspec from t2;
    .rmmCache.tf,::0!t2; //tf stores the cumulative per ticker data
    (first value first t3)  // return cumulative pnl

 };

L:(exec distinct date from trdDates where date within (begDt;endDt)) cross (-10 -5 -2 -1 0) cross (1);
tR:([]dt:(flip L)[0];offset:(flip L)[1];hldPeriod:(flip L)[2];result:reconstructedStaticOffset[;;;pos;npPriceClean;trdDates] ./: L);
tf set `date`sym`offsetDt`hldPeriod xasc `date`sym`offsetDt`hldPeriod xkey tf;


staticETFtot:sum_prevpnlmarklast*shares*etf_tot_return, 
staticETFfactor:sum_prevpnlmarklast*shares*etf_factor_return,
staticETFspec:sum_prevpnlmarklast*shares*etf_spec_return,

sum_prevpnlmarklast


`sumv5H`diff0_5H columns of interest
llSym:`date`mktcapBucketMM`advBucketMM`sym xasc 
        update 
	diff1_0:sumv0-sumv1,diff2_1:sumv1-sumv2,diff5_2:sumv2-sumv5,diff10_5:sumv5-sumv10 ,
	diff1_0H:sumv0H-sumv1H,diff2_1H:sumv1H-sumv2H,diff5_2H:sumv2H-sumv5H,diff10_5H:sumv5H-sumv10H,
	diff1_0etf:sumv0etf-sumv1etf,diff2_1etf:sumv1etf-sumv2etf,diff5_2etf:sumv2etf-sumv5etf,diff10_5etf:sumv5etf-sumv10etf,
	diff0_5:sumv0-sumv5,
	diff0_5H:sumv0H-sumv5H,
	diff0_5etf:sumv0etf-sumv5etf 
         from 
	 (select sumv2:sum static, sumv2H:sum staticHedged, sumv2etf:sum staticETFspec
	  by date,mktcapBucketMM,advBucketMM,sym from  tfAdv where offsetDt=-2,hldPeriod=1)
	 lj 
	 (select sumv0:sum static, sumv0H:sum staticHedged,netDynamic:sum netDynamic,sum notional, sumv0etf:sum staticETFspec  
	  by date,mktcapBucketMM,advBucketMM,sym from  tfAdv where offsetDt=0,hldPeriod=1) 
	 lj 
	 (select sumv5:sum static, sumv5H:sum staticHedged, sumv5etf:sum staticETFspec
	  by date,mktcapBucketMM,advBucketMM,sym from   tfAdv where offsetDt=-5,hldPeriod=1)  
	 lj 
	 (select sumv10:sum static, sumv10H:sum staticHedged,sumv10etf:sum staticETFspec 
	  by date,mktcapBucketMM,advBucketMM,sym from  tfAdv where offsetDt=-10,hldPeriod=1) 
	 lj 
	 select sumv1:sum static, sumv1H:sum staticHedged, sumv1etf:sum staticETFspec 
	  by date,mktcapBucketMM,advBucketMM,sym from  tfAdv  where offsetDt=-1,hldPeriod=1;
