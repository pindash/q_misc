replicating:{[exposure;criteria]
 m:count exposure;k:count first exposure;mk:m-k;
 B1:(mk:m-k)#exposure;
 B2:mk _ exposure; D:mmu[BI2:inv[flip B2];flip[B1]];
 I:(mk;mk)#-1f,mk #0f;D_tilde:I,D;
 t1:flip inv mmu[flip D_tilde;criteria*D_tilde];
 rp:{[mk;t1;BI2;dt;sigma;i]
  g:(mk#0f),BI2[;i];t2:enlist[g] mmu sigma*dt;
  raze g-mmu[dt;flip t2 mmu t1]
  }[mk;t1;BI2;D_tilde;criteria];
 rp each til k
 }
