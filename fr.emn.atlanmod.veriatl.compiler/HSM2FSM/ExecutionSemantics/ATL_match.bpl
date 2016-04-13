




procedure IS2IS_match(is1: ref) returns (r: bool);
  requires is1!=null && read($srcHeap, is1, alloc) && dtype(is1) <: HSM$InitialState 
;
  ensures r <==> ( printGuard_IS2IS($srcHeap, is1) );

function printGuard_IS2IS(hp: HeapType, is1: ref): bool
{  (read(hp, is1, HSM$AbstractState.compositeState)==null)  }



procedure IS2RS_match(is1: ref) returns (r: bool);
  requires is1!=null && read($srcHeap, is1, alloc) && dtype(is1) <: HSM$InitialState 
;
  ensures r <==> ( printGuard_IS2RS($srcHeap, is1) );

function printGuard_IS2RS(hp: HeapType, is1: ref): bool
{  !((read(hp, is1, HSM$AbstractState.compositeState)==null))  }



procedure T2TA_match(t1: ref) returns (r: bool);
  requires t1!=null && read($srcHeap, t1, alloc) && dtype(t1) <: HSM$Transition 
;
  ensures r <==> ( printGuard_T2TA($srcHeap, t1) );

function printGuard_T2TA(hp: HeapType, t1: ref): bool
{  !(dtype(read(hp, t1, HSM$Transition.source)) == HSM$CompositeState) && !(dtype(read(hp, t1, HSM$Transition.target)) == HSM$CompositeState)  }



procedure T2TB_match(t1: ref,src: ref,trg: ref,c: ref) returns (r: bool);
  requires t1!=null && read($srcHeap, t1, alloc) && dtype(t1) <: HSM$Transition 
 && src!=null && read($srcHeap, src, alloc) && dtype(src) <: HSM$CompositeState 
 && trg!=null && read($srcHeap, trg, alloc) && dtype(trg) <: HSM$AbstractState 
 && c!=null && read($srcHeap, c, alloc) && dtype(c) <: HSM$AbstractState 
;
  ensures r <==> ( printGuard_T2TB($srcHeap, t1,src,trg,c) );

function printGuard_T2TB(hp: HeapType, t1: ref,src: ref,trg: ref,c: ref): bool
{  read(hp, t1, HSM$Transition.source) == src && read(hp, t1, HSM$Transition.target) == trg && read(hp, c, HSM$AbstractState.compositeState) == src && !(dtype(trg) == HSM$CompositeState) && !(c == src)  }



procedure T2TC_match(t1: ref,src: ref,trg: ref,c: ref) returns (r: bool);
  requires t1!=null && read($srcHeap, t1, alloc) && dtype(t1) <: HSM$Transition 
 && src!=null && read($srcHeap, src, alloc) && dtype(src) <: HSM$AbstractState 
 && trg!=null && read($srcHeap, trg, alloc) && dtype(trg) <: HSM$CompositeState 
 && c!=null && read($srcHeap, c, alloc) && dtype(c) <: HSM$InitialState 
;
  ensures r <==> ( printGuard_T2TC($srcHeap, t1,src,trg,c) );

function printGuard_T2TC(hp: HeapType, t1: ref,src: ref,trg: ref,c: ref): bool
{  read(hp, t1, HSM$Transition.source) == src && read(hp, t1, HSM$Transition.target) == trg && read(hp, c, HSM$AbstractState.compositeState) == trg && !(dtype(src) == HSM$CompositeState)  }


