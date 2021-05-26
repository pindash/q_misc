/example blatantly copied from LEET CODE 
/https://leetcode.com/problems/sliding-window-maximum/
n:1 3 -1 -3 5 3 6 7
k:3
/mmax:{(x-1)|':/y}
p_mmax:{{max y x+z}[neg til x;y] peach til count[y]} /parallel with less memory overhead
/first attempt with dynamic programming
fast_mmax:{[k;n]
 l:{[k;x;y;z]$[z mod k;y|x z;x z]}[k;n]\[first n;til count n];
 r:reverse {[k;x;y;z]$[(z+1) mod k;y|x z;x z]}[k;n]\[last n;-1+count[n]-til count n];
 l|(k-1) xprev r}
/clean up 
/Good explanation here: http://www.zrzahid.com/sliding-window-minmax/
fast_mmax:{[k;n]l:raze maxs each w:(0N;k)#n;r:raze (reverse maxs reverse ::) each w;l|(k-1) xprev r}
/test
all {a:-20+50?40;b:1+rand 50;if[c:not fast_mmax[b;a]~mmax[b;a];`a`b set' (a;b)];not c}\[10000;1b]

/k4 version
mmax1:{l:,/|\'w:(0N;x)#y;r:,/(||\|::)'w;l|r(!#r)-(x-1)}





/
Python solution
import numpy as np 
def maxSlidingWindow(k,nums)
  cmax=np.maximum.accumulate
  #n=np.array(nums)
  n=len(nums)
  z=np.zeros(k*np.ceil(n/k).astype(int))
  z[:n]=nums
  z=z.reshape(-1,k)
  l=np.resize(cmax(z,1).reshape(z.size),n)
  r=np.resize(np.flip(cmax(np.flip(z,1),1),1).reshape(z.size),n)
  return list(np.max(np.stack([l[k-1:],r[:r.size-(k-1)]]),0).astype(int))
        
