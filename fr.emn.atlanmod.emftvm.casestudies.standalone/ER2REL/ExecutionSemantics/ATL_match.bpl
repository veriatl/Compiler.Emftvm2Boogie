






procedure EA2A_match(att: ref,ent: ref) returns (r: bool);
  requires att!=null && read($srcHeap, att, alloc) && dtype(att) <: ER$ERAttribute 
 && ent!=null && read($srcHeap, ent, alloc) && dtype(ent) <: ER$Entity 
;
  ensures r <==> ( printGuard_EA2A($srcHeap, att,ent) );

function printGuard_EA2A(hp: HeapType, att: ref,ent: ref): bool
{  read(hp, att, ER$ERAttribute.entity) == ent  }



procedure RA2A_match(att: ref,rs: ref) returns (r: bool);
  requires att!=null && read($srcHeap, att, alloc) && dtype(att) <: ER$ERAttribute 
 && rs!=null && read($srcHeap, rs, alloc) && dtype(rs) <: ER$Relship 
;
  ensures r <==> ( printGuard_RA2A($srcHeap, att,rs) );

function printGuard_RA2A(hp: HeapType, att: ref,rs: ref): bool
{  read(hp, att, ER$ERAttribute.relship) == rs  }



procedure RA2AK_match(att: ref,rse: ref) returns (r: bool);
  requires att!=null && read($srcHeap, att, alloc) && dtype(att) <: ER$ERAttribute 
 && rse!=null && read($srcHeap, rse, alloc) && dtype(rse) <: ER$RelshipEnd 
;
  ensures r <==> ( printGuard_RA2AK($srcHeap, att,rse) );

function printGuard_RA2AK(hp: HeapType, att: ref,rse: ref): bool
{  read(hp, att, ER$ERAttribute.entity) == read(hp, rse, ER$RelshipEnd.entity) && read(hp, att, ER$ERAttribute.isKey) == true  }


