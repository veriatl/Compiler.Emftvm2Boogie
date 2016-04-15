
procedure SM2SM_apply(__trace__: ref, sm1: ref, sm2: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(sm1) <: HSM$StateMachine;
free requires sm1 != null;
free requires read($srcHeap, sm1, alloc);


free requires dtype(sm2) <: FSM$StateMachine;
free requires sm2 != null;
free requires read($tarHeap, sm2, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Singleton(sm1)) == sm2;
// Guard
free requires true ;
// isValid Source model, to cooperate with resolve function.

// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(sm1)), FSM$StateMachine.name) == read($srcHeap, sm1, HSM$StateMachine.name);


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 1 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: HSM$StateMachine && ( dtype($o) <: FSM$StateMachine && ($f == FSM$StateMachine.name))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Singleton(sm1)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure RS2RS_apply(__trace__: ref, rs1: ref, rs2: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(rs1) <: HSM$RegularState;
free requires rs1 != null;
free requires read($srcHeap, rs1, alloc);


free requires dtype(rs2) <: FSM$RegularState;
free requires rs2 != null;
free requires read($tarHeap, rs2, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Singleton(rs1)) == rs2;
// Guard
free requires true ;
// isValid Source model, to cooperate with resolve function.

free requires dtype(read($srcHeap, rs1, HSM$AbstractState.stateMachine)) != class._System.array;
// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(rs1)), FSM$AbstractState.name) == read($srcHeap, rs1, HSM$AbstractState.name);
ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(rs1)), FSM$AbstractState.stateMachine) == getTarsBySrcs(Seq#Singleton(read($srcHeap, rs1, HSM$AbstractState.stateMachine)));


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 1 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: HSM$RegularState && ( dtype($o) <: FSM$RegularState && ($f == FSM$AbstractState.name || $f == FSM$AbstractState.stateMachine))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Singleton(rs1)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure IS2IS_apply(__trace__: ref, is1: ref, is2: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(is1) <: HSM$InitialState;
free requires is1 != null;
free requires read($srcHeap, is1, alloc);


free requires dtype(is2) <: FSM$InitialState;
free requires is2 != null;
free requires read($tarHeap, is2, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Singleton(is1)) == is2;
// Guard
free requires (read($srcHeap, is1, HSM$AbstractState.compositeState)==null) ;
// isValid Source model, to cooperate with resolve function.

free requires dtype(read($srcHeap, is1, HSM$AbstractState.stateMachine)) != class._System.array;
// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(is1)), FSM$AbstractState.stateMachine) == getTarsBySrcs(Seq#Singleton(read($srcHeap, is1, HSM$AbstractState.stateMachine)));
ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(is1)), FSM$AbstractState.name) == read($srcHeap, is1, HSM$AbstractState.name);


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 1 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: HSM$InitialState && ( dtype($o) <: FSM$InitialState && ($f == FSM$AbstractState.stateMachine || $f == FSM$AbstractState.name))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Singleton(is1)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure IS2RS_apply(__trace__: ref, is1: ref, is2: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(is1) <: HSM$InitialState;
free requires is1 != null;
free requires read($srcHeap, is1, alloc);


free requires dtype(is2) <: FSM$RegularState;
free requires is2 != null;
free requires read($tarHeap, is2, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Singleton(is1)) == is2;
// Guard
free requires !((read($srcHeap, is1, HSM$AbstractState.compositeState)==null)) ;
// isValid Source model, to cooperate with resolve function.

free requires dtype(read($srcHeap, is1, HSM$AbstractState.stateMachine)) != class._System.array;
// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(is1)), FSM$AbstractState.stateMachine) == getTarsBySrcs(Seq#Singleton(read($srcHeap, is1, HSM$AbstractState.stateMachine)));
ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(is1)), FSM$AbstractState.name) == read($srcHeap, is1, HSM$AbstractState.name);


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 1 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: HSM$InitialState && ( dtype($o) <: FSM$RegularState && ($f == FSM$AbstractState.stateMachine || $f == FSM$AbstractState.name))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Singleton(is1)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure T2TA_apply(__trace__: ref, t1: ref, t2: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(t1) <: HSM$Transition;
free requires t1 != null;
free requires read($srcHeap, t1, alloc);


free requires dtype(t2) <: FSM$Transition;
free requires t2 != null;
free requires read($tarHeap, t2, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Singleton(t1)) == t2;
// Guard
free requires !(dtype(read($srcHeap, t1, HSM$Transition.source)) == HSM$CompositeState) && !(dtype(read($srcHeap, t1, HSM$Transition.target)) == HSM$CompositeState) ;
// isValid Source model, to cooperate with resolve function.

free requires dtype(read($srcHeap, t1, HSM$Transition.stateMachine)) != class._System.array;
free requires dtype(read($srcHeap, t1, HSM$Transition.source)) != class._System.array;
free requires dtype(read($srcHeap, t1, HSM$Transition.target)) != class._System.array;
// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(t1)), FSM$Transition.label) == read($srcHeap, t1, HSM$Transition.label);
ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(t1)), FSM$Transition.stateMachine) == getTarsBySrcs(Seq#Singleton(read($srcHeap, t1, HSM$Transition.stateMachine)));
ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(t1)), FSM$Transition.source) == getTarsBySrcs(Seq#Singleton(read($srcHeap, t1, HSM$Transition.source)));
ensures read($tarHeap, getTarsBySrcs(Seq#Singleton(t1)), FSM$Transition.target) == getTarsBySrcs(Seq#Singleton(read($srcHeap, t1, HSM$Transition.target)));


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 1 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: HSM$Transition && ( dtype($o) <: FSM$Transition && ($f == FSM$Transition.label || $f == FSM$Transition.stateMachine || $f == FSM$Transition.source || $f == FSM$Transition.target))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Singleton(t1)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure T2TB_apply(__trace__: ref, t1: ref,src: ref,trg: ref,c: ref, t2: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(t1) <: HSM$Transition;
free requires t1 != null;
free requires read($srcHeap, t1, alloc);
free requires dtype(src) <: HSM$CompositeState;
free requires src != null;
free requires read($srcHeap, src, alloc);
free requires dtype(trg) <: HSM$AbstractState;
free requires trg != null;
free requires read($srcHeap, trg, alloc);
free requires dtype(c) <: HSM$AbstractState;
free requires c != null;
free requires read($srcHeap, c, alloc);


free requires dtype(t2) <: FSM$Transition;
free requires t2 != null;
free requires read($tarHeap, t2, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)) == t2;
// Guard
free requires read($srcHeap, t1, HSM$Transition.source) == src && read($srcHeap, t1, HSM$Transition.target) == trg && read($srcHeap, c, HSM$AbstractState.compositeState) == src && !(dtype(trg) == HSM$CompositeState) && !(c == src) ;
// isValid Source model, to cooperate with resolve function.

free requires dtype(read($srcHeap, t1, HSM$Transition.stateMachine)) != class._System.array;
// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)), FSM$Transition.label) == read($srcHeap, t1, HSM$Transition.label);
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)), FSM$Transition.stateMachine) == getTarsBySrcs(Seq#Singleton(read($srcHeap, t1, HSM$Transition.stateMachine)));
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)), FSM$Transition.source) == getTarsBySrcs(Seq#Singleton(c));
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)), FSM$Transition.target) == getTarsBySrcs(Seq#Singleton(trg));


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 4 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: HSM$Transition && dtype(Seq#Index(getTarsBySrcs_inverse($o), 1)) <: HSM$CompositeState && dtype(Seq#Index(getTarsBySrcs_inverse($o), 2)) <: HSM$AbstractState && dtype(Seq#Index(getTarsBySrcs_inverse($o), 3)) <: HSM$AbstractState && ( dtype($o) <: FSM$Transition && ($f == FSM$Transition.label || $f == FSM$Transition.stateMachine || $f == FSM$Transition.source || $f == FSM$Transition.target))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);

procedure T2TC_apply(__trace__: ref, t1: ref,src: ref,trg: ref,c: ref, t2: ref) returns();
free requires surj_tar_model($srcHeap, $tarHeap);
// rule info
free requires dtype(t1) <: HSM$Transition;
free requires t1 != null;
free requires read($srcHeap, t1, alloc);
free requires dtype(src) <: HSM$AbstractState;
free requires src != null;
free requires read($srcHeap, src, alloc);
free requires dtype(trg) <: HSM$CompositeState;
free requires trg != null;
free requires read($srcHeap, trg, alloc);
free requires dtype(c) <: HSM$InitialState;
free requires c != null;
free requires read($srcHeap, c, alloc);


free requires dtype(t2) <: FSM$Transition;
free requires t2 != null;
free requires read($tarHeap, t2, alloc);

// Correspondence I/O
free requires getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)) == t2;
// Guard
free requires read($srcHeap, t1, HSM$Transition.source) == src && read($srcHeap, t1, HSM$Transition.target) == trg && read($srcHeap, c, HSM$AbstractState.compositeState) == trg && !(dtype(src) == HSM$CompositeState) ;
// isValid Source model, to cooperate with resolve function.

free requires dtype(read($srcHeap, t1, HSM$Transition.stateMachine)) != class._System.array;
// isValid Target model, i.e. associations are populated with empty array.

// modifies
modifies $tarHeap;
// Rule outcome

ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)), FSM$Transition.label) == read($srcHeap, t1, HSM$Transition.label);
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)), FSM$Transition.stateMachine) == getTarsBySrcs(Seq#Singleton(read($srcHeap, t1, HSM$Transition.stateMachine)));
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)), FSM$Transition.source) == getTarsBySrcs(Seq#Singleton(src));
ensures read($tarHeap, getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)), FSM$Transition.target) == getTarsBySrcs(Seq#Singleton(c));


// Frame 
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	!read(old($tarHeap), $o, alloc) ==>
		 ( read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
	  || (dtype($o) == class._System.array));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) ==>
		(Seq#Length(getTarsBySrcs_inverse($o)) == 4 && dtype(Seq#Index(getTarsBySrcs_inverse($o), 0)) <: HSM$Transition && dtype(Seq#Index(getTarsBySrcs_inverse($o), 1)) <: HSM$AbstractState && dtype(Seq#Index(getTarsBySrcs_inverse($o), 2)) <: HSM$CompositeState && dtype(Seq#Index(getTarsBySrcs_inverse($o), 3)) <: HSM$InitialState && ( dtype($o) <: FSM$Transition && ($f == FSM$Transition.label || $f == FSM$Transition.stateMachine || $f == FSM$Transition.source || $f == FSM$Transition.target))) 
		|| (read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f)));
ensures (forall<alpha> $o: ref, $f: Field alpha :: 
	$o != null && read(old($tarHeap), $o, alloc) && $o != getTarsBySrcs(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(t1),src),trg),c)) ==> 
	(read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f))
  );
// Preserving
free ensures $HeapSucc(old($tarHeap), $tarHeap);
free ensures surj_tar_model($srcHeap, $tarHeap);



