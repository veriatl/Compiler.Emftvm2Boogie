
procedure S2S_apply(__trace__: ref, s: ref, t: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(s) <: ER$ERSchema;
free requires s != null;
free requires read($srcHeap, s, alloc);


free requires dtype(t) <: REL$RELSchema;
free requires t != null;
free requires read($tarHeap, t, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Singleton(s)) == t;
// Guard
free requires true ;
// isValid Source model, to cooperate with resolve function.

free requires dtype(read($srcHeap, s, ER$ERSchema.entities)) == class._System.array;
free requires dtype(read($srcHeap, s, ER$ERSchema.relships)) == class._System.array;
// isValid Target model, i.e. associations are populated with empty array.

free requires Seq#FromArray($tarHeap, read($tarHeap, t, REL$RELSchema.relations)) == Seq#Empty();
free requires Seq#FromArray($tarHeap, read($tarHeap, t, REL$RELSchema.relations)) == Seq#Empty();
// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(s)), REL$RELSchema.name) == read($srcHeap, s, ER$ERSchema.name);
ensures dtype(read($tarHeap, getTarsBySrcs(Seq#Singleton(s)), REL$RELSchema.relations)) == class._System.array
&&       read($tarHeap, getTarsBySrcs(Seq#Singleton(s)), REL$RELSchema.relations) != null
&&       read($tarHeap, read($tarHeap, getTarsBySrcs(Seq#Singleton(s)), REL$RELSchema.relations), alloc)
&&       (_System.array.Length(read($tarHeap, getTarsBySrcs(Seq#Singleton(s)), REL$RELSchema.relations)) == _System.array.Length(read($srcHeap, s, ER$ERSchema.entities)) + _System.array.Length(read($srcHeap, s, ER$ERSchema.relships)))
&&       ( forall __j: int :: 0<=__j && __j<_System.array.Length(read($srcHeap, s, ER$ERSchema.entities)) ==> $Unbox(read($tarHeap, read($tarHeap, getTarsBySrcs(Seq#Singleton(s)), REL$RELSchema.relations), IndexField(__j))): ref == getTarsBySrcs(Seq#Singleton( $Unbox(read($srcHeap, read($srcHeap, s, ER$ERSchema.entities), IndexField(__j))): ref) ))
&&       ( forall __j: int :: 0<=__j && __j<_System.array.Length(read($srcHeap, s, ER$ERSchema.relships)) ==> $Unbox(read($tarHeap, read($tarHeap, getTarsBySrcs(Seq#Singleton(s)), REL$RELSchema.relations), IndexField(__j+_System.array.Length(read($srcHeap, s, ER$ERSchema.entities))))): ref == getTarsBySrcs(Seq#Singleton( $Unbox(read($srcHeap, read($srcHeap, s, ER$ERSchema.relships), IndexField(__j))): ref) ));

ensures  true ;



// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 1 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: ER$ERSchema && ( dtype($o) <: REL$RELSchema && ($f == REL$RELSchema.name || $f == REL$RELSchema.relations || $f == REL$RELSchema.relations))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Singleton(s)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure E2R_apply(__trace__: ref, s: ref, t: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(s) <: ER$Entity;
free requires s != null;
free requires read($srcHeap, s, alloc);


free requires dtype(t) <: REL$Relation;
free requires t != null;
free requires read($tarHeap, t, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Singleton(s)) == t;
// Guard
free requires true ;
// isValid Source model, to cooperate with resolve function.

// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(s)), REL$Relation.name) == read($srcHeap, s, ER$Entity.name);


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 1 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: ER$Entity && ( dtype($o) <: REL$Relation && ($f == REL$Relation.name))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Singleton(s)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure R2R_apply(__trace__: ref, s: ref, t: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(s) <: ER$Relship;
free requires s != null;
free requires read($srcHeap, s, alloc);


free requires dtype(t) <: REL$Relation;
free requires t != null;
free requires read($tarHeap, t, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Singleton(s)) == t;
// Guard
free requires true ;
// isValid Source model, to cooperate with resolve function.

// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(s)), REL$Relation.name) == read($srcHeap, s, ER$Relship.name);


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 1 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: ER$Relship && ( dtype($o) <: REL$Relation && ($f == REL$Relation.name))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Singleton(s)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure EA2A_apply(__trace__: ref, att: ref,ent: ref, t: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(att) <: ER$ERAttribute;
free requires att != null;
free requires read($srcHeap, att, alloc);
free requires dtype(ent) <: ER$Entity;
free requires ent != null;
free requires read($srcHeap, ent, alloc);


free requires dtype(t) <: REL$RELAttribute;
free requires t != null;
free requires read($tarHeap, t, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Build(Seq#Singleton(att),ent)) == t;
// Guard
free requires read($srcHeap, att, ER$ERAttribute.entity) == ent ;
// isValid Source model, to cooperate with resolve function.

// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Singleton(att),ent)), REL$RELAttribute.name) == read($srcHeap, att, ER$ERAttribute.name);
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Singleton(att),ent)), REL$RELAttribute.isKey) == read($srcHeap, att, ER$ERAttribute.isKey);
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Singleton(att),ent)), REL$RELAttribute.relation) == getTarsBySrcs(Seq#Singleton(ent));


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 2 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: ER$ERAttribute && dtype(Seq#Index(getTarsBySrcs_inverse($o), 1)) <: ER$Entity && ( dtype($o) <: REL$RELAttribute && ($f == REL$RELAttribute.name || $f == REL$RELAttribute.isKey || $f == REL$RELAttribute.relation))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Build(Seq#Singleton(att),ent)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure RA2A_apply(__trace__: ref, att: ref,rs: ref, t: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(att) <: ER$ERAttribute;
free requires att != null;
free requires read($srcHeap, att, alloc);
free requires dtype(rs) <: ER$Relship;
free requires rs != null;
free requires read($srcHeap, rs, alloc);


free requires dtype(t) <: REL$RELAttribute;
free requires t != null;
free requires read($tarHeap, t, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Build(Seq#Singleton(att),rs)) == t;
// Guard
free requires read($srcHeap, att, ER$ERAttribute.relship) == rs ;
// isValid Source model, to cooperate with resolve function.

// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Singleton(att),rs)), REL$RELAttribute.name) == read($srcHeap, att, ER$ERAttribute.name);
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Singleton(att),rs)), REL$RELAttribute.isKey) == read($srcHeap, att, ER$ERAttribute.isKey);
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Singleton(att),rs)), REL$RELAttribute.relation) == getTarsBySrcs(Seq#Singleton(rs));


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 2 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: ER$ERAttribute && dtype(Seq#Index(getTarsBySrcs_inverse($o), 1)) <: ER$Relship && ( dtype($o) <: REL$RELAttribute && ($f == REL$RELAttribute.name || $f == REL$RELAttribute.isKey || $f == REL$RELAttribute.relation))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Build(Seq#Singleton(att),rs)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure RA2AK_apply(__trace__: ref, att: ref,rse: ref, t: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(att) <: ER$ERAttribute;
free requires att != null;
free requires read($srcHeap, att, alloc);
free requires dtype(rse) <: ER$RelshipEnd;
free requires rse != null;
free requires read($srcHeap, rse, alloc);


free requires dtype(t) <: REL$RELAttribute;
free requires t != null;
free requires read($tarHeap, t, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Build(Seq#Singleton(att),rse)) == t;
// Guard
free requires read($srcHeap, att, ER$ERAttribute.entity) == read($srcHeap, rse, ER$RelshipEnd.entity) && read($srcHeap, att, ER$ERAttribute.isKey) == true ;
// isValid Source model, to cooperate with resolve function.

free requires dtype(read($srcHeap, rse, ER$RelshipEnd.relship)) != class._System.array;
// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Singleton(att),rse)), REL$RELAttribute.name) == read($srcHeap, att, ER$ERAttribute.name);
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Singleton(att),rse)), REL$RELAttribute.isKey) == read($srcHeap, att, ER$ERAttribute.isKey);
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Singleton(att),rse)), REL$RELAttribute.relation) == getTarsBySrcs(Seq#Singleton(read($srcHeap, rse, ER$RelshipEnd.relship)));


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 2 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: ER$ERAttribute && dtype(Seq#Index(getTarsBySrcs_inverse($o), 1)) <: ER$RelshipEnd && ( dtype($o) <: REL$RELAttribute && ($f == REL$RELAttribute.name || $f == REL$RELAttribute.isKey || $f == REL$RELAttribute.relation))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Build(Seq#Singleton(att),rse)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);



