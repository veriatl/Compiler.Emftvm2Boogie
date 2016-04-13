function findPatterns_PlayerMoveLeft(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_PlayerMoveLeft(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i)) == 6)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),1)) == pacman$Record
	 )
);
// pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),2)) == pacman$Pacman
	 )
);
// grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),3)) == pacman$Grid
	 )
);
// grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),4)) == pacman$Grid
	 )
);
// act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),5) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 5),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),5)) == pacman$Action
	 )
);
//injective matching
axiom (forall _hp: HeapType ::
		(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
			Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),3) != Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i),4)));
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 4), pacman$Grid.hasPlayer) == Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 2)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveLeft(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 4), pacman$Grid.left) == Seq#Index(Seq#Index(findPatterns_PlayerMoveLeft(_hp),i), 3)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, pac, grid2, grid1, act: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman
		&& grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid
		&& grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid
		&& act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action
		&& grid2 != grid1
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid1, pacman$Grid.hasPlayer) == pac
		&& read(_hp, grid1, pacman$Grid.left) == grid2
		==> 	
		Seq#Contains(findPatterns_PlayerMoveLeft(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),grid2),grid1),act))
	)	
);	




function findPatterns_PlayerMoveRight(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_PlayerMoveRight(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_PlayerMoveRight(_hp),i)) == 6)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),1)) == pacman$Record
	 )
);
// pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),2)) == pacman$Pacman
	 )
);
// grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),3)) == pacman$Grid
	 )
);
// grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),4)) == pacman$Grid
	 )
);
// act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),5) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 5),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),5)) == pacman$Action
	 )
);
//injective matching
axiom (forall _hp: HeapType ::
		(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
			Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),3) != Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i),4)));
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 4), pacman$Grid.hasPlayer) == Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 2)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveRight(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 4), pacman$Grid.right) == Seq#Index(Seq#Index(findPatterns_PlayerMoveRight(_hp),i), 3)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, pac, grid2, grid1, act: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman
		&& grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid
		&& grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid
		&& act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action
		&& grid2 != grid1
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid1, pacman$Grid.hasPlayer) == pac
		&& read(_hp, grid1, pacman$Grid.right) == grid2
		==> 	
		Seq#Contains(findPatterns_PlayerMoveRight(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),grid2),grid1),act))
	)	
);	




function findPatterns_PlayerMoveTop(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_PlayerMoveTop(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_PlayerMoveTop(_hp),i)) == 6)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),1)) == pacman$Record
	 )
);
// pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),2)) == pacman$Pacman
	 )
);
// grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),3)) == pacman$Grid
	 )
);
// grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),4)) == pacman$Grid
	 )
);
// act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),5) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 5),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),5)) == pacman$Action
	 )
);
//injective matching
axiom (forall _hp: HeapType ::
		(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
			Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),3) != Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i),4)));
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 4), pacman$Grid.hasPlayer) == Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 2)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveTop(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 4), pacman$Grid.top) == Seq#Index(Seq#Index(findPatterns_PlayerMoveTop(_hp),i), 3)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, pac, grid2, grid1, act: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman
		&& grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid
		&& grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid
		&& act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action
		&& grid2 != grid1
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid1, pacman$Grid.hasPlayer) == pac
		&& read(_hp, grid1, pacman$Grid.top) == grid2
		==> 	
		Seq#Contains(findPatterns_PlayerMoveTop(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),grid2),grid1),act))
	)	
);	




function findPatterns_PlayerMoveBottom(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_PlayerMoveBottom(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i)) == 6)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),1)) == pacman$Record
	 )
);
// pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),2)) == pacman$Pacman
	 )
);
// grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),3)) == pacman$Grid
	 )
);
// grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),4)) == pacman$Grid
	 )
);
// act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),5) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 5),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),5)) == pacman$Action
	 )
);
//injective matching
axiom (forall _hp: HeapType ::
		(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
			Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),3) != Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i),4)));
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 4), pacman$Grid.hasPlayer) == Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 2)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerMoveBottom(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 4), pacman$Grid.bottom) == Seq#Index(Seq#Index(findPatterns_PlayerMoveBottom(_hp),i), 3)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, pac, grid2, grid1, act: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman
		&& grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid
		&& grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid
		&& act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action
		&& grid2 != grid1
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid1, pacman$Grid.hasPlayer) == pac
		&& read(_hp, grid1, pacman$Grid.bottom) == grid2
		==> 	
		Seq#Contains(findPatterns_PlayerMoveBottom(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),grid2),grid1),act))
	)	
);	




function findPatterns_PlayerStay(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_PlayerStay(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerStay(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_PlayerStay(_hp),i)) == 5)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerStay(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerStay(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i),1)) == pacman$Record
	 )
);
// pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerStay(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i),2)) == pacman$Pacman
	 )
);
// grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerStay(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i),3)) == pacman$Grid
	 )
);
// act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerStay(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i),4)) == pacman$Action
	 )
);
//injective matching
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerStay(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_PlayerStay(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i), 3), pacman$Grid.hasPlayer) == Seq#Index(Seq#Index(findPatterns_PlayerStay(_hp),i), 2)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, pac, grid1, act: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman
		&& grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid
		&& act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid1, pacman$Grid.hasPlayer) == pac
		==> 	
		Seq#Contains(findPatterns_PlayerStay(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),grid1),act))
	)	
);	




function findPatterns_ghostMoveLeft(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_ghostMoveLeft(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_ghostMoveLeft(_hp),i)) == 6)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),1)) == pacman$Record
	 )
);
// ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),2)) == pacman$Ghost
	 )
);
// grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),3)) == pacman$Grid
	 )
);
// grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),4)) == pacman$Grid
	 )
);
// act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),5) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 5),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),5)) == pacman$Action
	 )
);
//injective matching
axiom (forall _hp: HeapType ::
		(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
			Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),3) != Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i),4)));
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 4), pacman$Grid.hasEnemy) == Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 2)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveLeft(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 4), pacman$Grid.left) == Seq#Index(Seq#Index(findPatterns_ghostMoveLeft(_hp),i), 3)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, ghost, grid2, grid1, act: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost
		&& grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid
		&& grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid
		&& act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action
		&& grid2 != grid1
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid1, pacman$Grid.hasEnemy) == ghost
		&& read(_hp, grid1, pacman$Grid.left) == grid2
		==> 	
		Seq#Contains(findPatterns_ghostMoveLeft(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),ghost),grid2),grid1),act))
	)	
);	




function findPatterns_ghostMoveRight(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_ghostMoveRight(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_ghostMoveRight(_hp),i)) == 6)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),1)) == pacman$Record
	 )
);
// ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),2)) == pacman$Ghost
	 )
);
// grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),3)) == pacman$Grid
	 )
);
// grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),4)) == pacman$Grid
	 )
);
// act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),5) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 5),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),5)) == pacman$Action
	 )
);
//injective matching
axiom (forall _hp: HeapType ::
		(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
			Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),3) != Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i),4)));
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 4), pacman$Grid.hasEnemy) == Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 2)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveRight(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 4), pacman$Grid.right) == Seq#Index(Seq#Index(findPatterns_ghostMoveRight(_hp),i), 3)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, ghost, grid2, grid1, act: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost
		&& grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid
		&& grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid
		&& act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action
		&& grid2 != grid1
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid1, pacman$Grid.hasEnemy) == ghost
		&& read(_hp, grid1, pacman$Grid.right) == grid2
		==> 	
		Seq#Contains(findPatterns_ghostMoveRight(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),ghost),grid2),grid1),act))
	)	
);	




function findPatterns_ghostMoveTop(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_ghostMoveTop(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_ghostMoveTop(_hp),i)) == 6)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),1)) == pacman$Record
	 )
);
// ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),2)) == pacman$Ghost
	 )
);
// grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),3)) == pacman$Grid
	 )
);
// grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),4)) == pacman$Grid
	 )
);
// act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),5) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 5),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),5)) == pacman$Action
	 )
);
//injective matching
axiom (forall _hp: HeapType ::
		(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
			Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),3) != Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i),4)));
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 4), pacman$Grid.hasEnemy) == Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 2)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveTop(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 4), pacman$Grid.top) == Seq#Index(Seq#Index(findPatterns_ghostMoveTop(_hp),i), 3)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, ghost, grid2, grid1, act: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost
		&& grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid
		&& grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid
		&& act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action
		&& grid2 != grid1
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid1, pacman$Grid.hasEnemy) == ghost
		&& read(_hp, grid1, pacman$Grid.top) == grid2
		==> 	
		Seq#Contains(findPatterns_ghostMoveTop(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),ghost),grid2),grid1),act))
	)	
);	




function findPatterns_ghostMoveBottom(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_ghostMoveBottom(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_ghostMoveBottom(_hp),i)) == 6)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),1)) == pacman$Record
	 )
);
// ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),2)) == pacman$Ghost
	 )
);
// grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),3)) == pacman$Grid
	 )
);
// grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),4)) == pacman$Grid
	 )
);
// act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),5) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 5),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),5)) == pacman$Action
	 )
);
//injective matching
axiom (forall _hp: HeapType ::
		(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
			Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),3) != Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i),4)));
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 4), pacman$Grid.hasEnemy) == Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 2)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostMoveBottom(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 4), pacman$Grid.bottom) == Seq#Index(Seq#Index(findPatterns_ghostMoveBottom(_hp),i), 3)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, ghost, grid2, grid1, act: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost
		&& grid2 != null && read(_hp, grid2, alloc) && dtype(grid2) <: pacman$Grid
		&& grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid
		&& act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action
		&& grid2 != grid1
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid1, pacman$Grid.hasEnemy) == ghost
		&& read(_hp, grid1, pacman$Grid.bottom) == grid2
		==> 	
		Seq#Contains(findPatterns_ghostMoveBottom(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),ghost),grid2),grid1),act))
	)	
);	




function findPatterns_ghostStay(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_ghostStay(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostStay(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_ghostStay(_hp),i)) == 5)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostStay(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostStay(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i),1)) == pacman$Record
	 )
);
// ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostStay(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i),2)) == pacman$Ghost
	 )
);
// grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostStay(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i),3)) == pacman$Grid
	 )
);
// act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostStay(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i),4)) == pacman$Action
	 )
);
//injective matching
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostStay(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_ghostStay(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i), 3), pacman$Grid.hasEnemy) == Seq#Index(Seq#Index(findPatterns_ghostStay(_hp),i), 2)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, ghost, grid1, act: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost
		&& grid1 != null && read(_hp, grid1, alloc) && dtype(grid1) <: pacman$Grid
		&& act != null && read(_hp, act, alloc) && dtype(act) <: pacman$Action
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid1, pacman$Grid.hasEnemy) == ghost
		==> 	
		Seq#Contains(findPatterns_ghostStay(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),ghost),grid1),act))
	)	
);	




function findPatterns_Collect(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_Collect(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Collect(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_Collect(_hp),i)) == 5)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Collect(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_Collect(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_Collect(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Collect(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_Collect(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_Collect(_hp),i),1)) == pacman$Record
	 )
);
// pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Collect(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_Collect(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_Collect(_hp),i),2)) == pacman$Pacman
	 )
);
// gem != null && read(_hp, gem, alloc) && dtype(gem) <: pacman$Gem;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Collect(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_Collect(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_Collect(_hp),i),3)) == pacman$Gem
	 )
);
// grid != null && read(_hp, grid, alloc) && dtype(grid) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Collect(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_Collect(_hp),i),4) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 4),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_Collect(_hp),i),4)) == pacman$Grid
	 )
);
//injective matching
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Collect(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 1)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Collect(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 4), pacman$Grid.hasPlayer) == Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 2)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Collect(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 4), pacman$Grid.hasGem) == Seq#Index(Seq#Index(findPatterns_Collect(_hp),i), 3)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, pac, gem, grid: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman
		&& gem != null && read(_hp, gem, alloc) && dtype(gem) <: pacman$Gem
		&& grid != null && read(_hp, grid, alloc) && dtype(grid) <: pacman$Grid
		&& read(_hp, s, pacman$GameState.record) == rec
		&& read(_hp, grid, pacman$Grid.hasPlayer) == pac
		&& read(_hp, grid, pacman$Grid.hasGem) == gem
		==> 	
		Seq#Contains(findPatterns_Collect(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),gem),grid))
	)	
);	




function findPatterns_Kill(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_Kill(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Kill(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_Kill(_hp),i)) == 4)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Kill(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_Kill(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_Kill(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_Kill(_hp),i),0)) == pacman$GameState
	 )
);
// ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Kill(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_Kill(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_Kill(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_Kill(_hp),i),1)) == pacman$Ghost
	 )
);
// pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Kill(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_Kill(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_Kill(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_Kill(_hp),i),2)) == pacman$Pacman
	 )
);
// grid != null && read(_hp, grid, alloc) && dtype(grid) <: pacman$Grid;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Kill(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_Kill(_hp),i),3) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_Kill(_hp),i), 3),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_Kill(_hp),i),3)) == pacman$Grid
	 )
);
//injective matching
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Kill(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_Kill(_hp),i), 3), pacman$Grid.hasPlayer) == Seq#Index(Seq#Index(findPatterns_Kill(_hp),i), 2)
	)
);
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_Kill(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_Kill(_hp),i), 3), pacman$Grid.hasEnemy) == Seq#Index(Seq#Index(findPatterns_Kill(_hp),i), 1)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, ghost, pac, grid: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& ghost != null && read(_hp, ghost, alloc) && dtype(ghost) <: pacman$Ghost
		&& pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman
		&& grid != null && read(_hp, grid, alloc) && dtype(grid) <: pacman$Grid
		&& read(_hp, grid, pacman$Grid.hasPlayer) == pac
		&& read(_hp, grid, pacman$Grid.hasEnemy) == ghost
		==> 	
		Seq#Contains(findPatterns_Kill(_hp), Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),ghost),pac),grid))
	)	
);	




function findPatterns_UpdateFrame(_hp: HeapType): Seq (Seq ref);
// structure filter
axiom (forall _hp: HeapType :: Seq#Length(findPatterns_UpdateFrame(_hp)) >= 0);
// input elements size
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_UpdateFrame(_hp))) ==> 
		Seq#Length(Seq#Index(findPatterns_UpdateFrame(_hp),i)) == 3)
);
// s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_UpdateFrame(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i),0) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i), 0),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i),0)) == pacman$GameState
	 )
);
// rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_UpdateFrame(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i),1) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i), 1),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i),1)) == pacman$Record
	 )
);
// pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman;
axiom (forall _hp: HeapType ::	
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_UpdateFrame(_hp))) ==> 
		Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i),2) != null 
		&& read(_hp,Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i), 2),alloc) 
		&& dtype(Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i),2)) == pacman$Pacman
	 )
);
//injective matching
// structural matching
axiom (forall _hp: HeapType ::
	(forall i: int :: inRange(i,0,Seq#Length(findPatterns_UpdateFrame(_hp))) ==> 
		 read(_hp, Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i), 0), pacman$GameState.record) == Seq#Index(Seq#Index(findPatterns_UpdateFrame(_hp),i), 1)
	)
);
// surjective
axiom (forall _hp: HeapType ::
	(forall s, rec, pac: ref ::
		true
		&& s != null && read(_hp, s, alloc) && dtype(s) <: pacman$GameState
		&& rec != null && read(_hp, rec, alloc) && dtype(rec) <: pacman$Record
		&& pac != null && read(_hp, pac, alloc) && dtype(pac) <: pacman$Pacman
		&& read(_hp, s, pacman$GameState.record) == rec
		==> 	
		Seq#Contains(findPatterns_UpdateFrame(_hp), Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac))
	)	
);	




