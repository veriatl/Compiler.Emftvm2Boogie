procedure PlayerMoveLeft_apply(__trace__: ref,s: ref, rec: ref, pac: ref, grid2: ref, grid1: ref, act: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_PlayerMoveLeft($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),grid2),grid1),act));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 3;
requires read($srcHeap, act, pacman$Action.DONEBY) == 1;
requires read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	;
requires read($srcHeap, act, pacman$Action.DIRECTION) == 1;
// nac
requires !(dtype(read($srcHeap, grid2, pacman$Grid.hasEnemy)) <: pacman$Ghost);
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid1, pacman$Grid.hasPlayer);
requires isset($acc, grid1, pacman$Grid.left);
requires isset($acc, act, pacman$Action.DONEBY);
requires isset($acc, act, pacman$Action.FRAME);
requires isset($acc, act, pacman$Action.DIRECTION);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, act, alloc);
ensures read($srcHeap, grid1, pacman$Grid.hasPlayer) == null;
ensures !isset($acc, grid1, pacman$Grid.hasPlayer);
ensures read($srcHeap, act, pacman$Action.DONEBY) == 0;
ensures !isset($acc, act, pacman$Action.DONEBY);
ensures read($srcHeap, act, pacman$Action.DIRECTION) == 0;
ensures !isset($acc, act, pacman$Action.DIRECTION);
ensures read($srcHeap, s, pacman$GameState.STATE) == 4;
ensures read($srcHeap, act, pacman$Action.FRAME) == 0;
ensures !isset($acc, act, pacman$Action.FRAME);
ensures read($srcHeap, grid2, pacman$Grid.hasPlayer) == pac;
ensures isset($acc, grid2, pacman$Grid.hasPlayer);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasPlayer))||
  (o == grid2 && ( f == pacman$Grid.hasPlayer))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasPlayer))||
  (o == grid2 && ( f == pacman$Grid.hasPlayer))
);

procedure PlayerMoveRight_apply(__trace__: ref,s: ref, rec: ref, pac: ref, grid2: ref, grid1: ref, act: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_PlayerMoveRight($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),grid2),grid1),act));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 3;
requires read($srcHeap, act, pacman$Action.DONEBY) == 1;
requires read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	;
requires read($srcHeap, act, pacman$Action.DIRECTION) == 2;
// nac
requires !(dtype(read($srcHeap, grid2, pacman$Grid.hasEnemy)) <: pacman$Ghost);
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid1, pacman$Grid.hasPlayer);
requires isset($acc, grid1, pacman$Grid.right);
requires isset($acc, act, pacman$Action.DONEBY);
requires isset($acc, act, pacman$Action.FRAME);
requires isset($acc, act, pacman$Action.DIRECTION);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, act, alloc);
ensures read($srcHeap, grid1, pacman$Grid.hasPlayer) == null;
ensures !isset($acc, grid1, pacman$Grid.hasPlayer);
ensures read($srcHeap, act, pacman$Action.DONEBY) == 0;
ensures !isset($acc, act, pacman$Action.DONEBY);
ensures read($srcHeap, act, pacman$Action.DIRECTION) == 0;
ensures !isset($acc, act, pacman$Action.DIRECTION);
ensures read($srcHeap, s, pacman$GameState.STATE) == 4;
ensures read($srcHeap, act, pacman$Action.FRAME) == 0;
ensures !isset($acc, act, pacman$Action.FRAME);
ensures read($srcHeap, grid2, pacman$Grid.hasPlayer) == pac;
ensures isset($acc, grid2, pacman$Grid.hasPlayer);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasPlayer))||
  (o == grid2 && ( f == pacman$Grid.hasPlayer))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasPlayer))||
  (o == grid2 && ( f == pacman$Grid.hasPlayer))
);

procedure PlayerMoveTop_apply(__trace__: ref,s: ref, rec: ref, pac: ref, grid2: ref, grid1: ref, act: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_PlayerMoveTop($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),grid2),grid1),act));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 3;
requires read($srcHeap, act, pacman$Action.DONEBY) == 1;
requires read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	;
requires read($srcHeap, act, pacman$Action.DIRECTION) == 3;
// nac
requires !(dtype(read($srcHeap, grid2, pacman$Grid.hasEnemy)) <: pacman$Ghost);
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid1, pacman$Grid.hasPlayer);
requires isset($acc, grid1, pacman$Grid.top);
requires isset($acc, act, pacman$Action.DONEBY);
requires isset($acc, act, pacman$Action.FRAME);
requires isset($acc, act, pacman$Action.DIRECTION);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, act, alloc);
ensures read($srcHeap, grid1, pacman$Grid.hasPlayer) == null;
ensures !isset($acc, grid1, pacman$Grid.hasPlayer);
ensures read($srcHeap, act, pacman$Action.DONEBY) == 0;
ensures !isset($acc, act, pacman$Action.DONEBY);
ensures read($srcHeap, act, pacman$Action.DIRECTION) == 0;
ensures !isset($acc, act, pacman$Action.DIRECTION);
ensures read($srcHeap, s, pacman$GameState.STATE) == 4;
ensures read($srcHeap, act, pacman$Action.FRAME) == 0;
ensures !isset($acc, act, pacman$Action.FRAME);
ensures read($srcHeap, grid2, pacman$Grid.hasPlayer) == pac;
ensures isset($acc, grid2, pacman$Grid.hasPlayer);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasPlayer))||
  (o == grid2 && ( f == pacman$Grid.hasPlayer))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasPlayer))||
  (o == grid2 && ( f == pacman$Grid.hasPlayer))
);

procedure PlayerMoveBottom_apply(__trace__: ref,s: ref, rec: ref, pac: ref, grid2: ref, grid1: ref, act: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_PlayerMoveBottom($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),grid2),grid1),act));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 3;
requires read($srcHeap, act, pacman$Action.DONEBY) == 1;
requires read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	;
requires read($srcHeap, act, pacman$Action.DIRECTION) == 4;
// nac
requires !(dtype(read($srcHeap, grid2, pacman$Grid.hasEnemy)) <: pacman$Ghost);
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid1, pacman$Grid.hasPlayer);
requires isset($acc, grid1, pacman$Grid.bottom);
requires isset($acc, act, pacman$Action.DONEBY);
requires isset($acc, act, pacman$Action.FRAME);
requires isset($acc, act, pacman$Action.DIRECTION);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, act, alloc);
ensures read($srcHeap, grid1, pacman$Grid.hasPlayer) == null;
ensures !isset($acc, grid1, pacman$Grid.hasPlayer);
ensures read($srcHeap, act, pacman$Action.DONEBY) == 0;
ensures !isset($acc, act, pacman$Action.DONEBY);
ensures read($srcHeap, act, pacman$Action.DIRECTION) == 0;
ensures !isset($acc, act, pacman$Action.DIRECTION);
ensures read($srcHeap, s, pacman$GameState.STATE) == 4;
ensures read($srcHeap, act, pacman$Action.FRAME) == 0;
ensures !isset($acc, act, pacman$Action.FRAME);
ensures read($srcHeap, grid2, pacman$Grid.hasPlayer) == pac;
ensures isset($acc, grid2, pacman$Grid.hasPlayer);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasPlayer))||
  (o == grid2 && ( f == pacman$Grid.hasPlayer))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasPlayer))||
  (o == grid2 && ( f == pacman$Grid.hasPlayer))
);

procedure PlayerStay_apply(__trace__: ref,s: ref, rec: ref, pac: ref, grid1: ref, act: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_PlayerStay($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),grid1),act));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 3;
requires read($srcHeap, act, pacman$Action.DONEBY) == 1;
requires read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	;
requires read($srcHeap, act, pacman$Action.DIRECTION) == 5;
// nac
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid1, pacman$Grid.hasPlayer);
requires isset($acc, act, pacman$Action.DONEBY);
requires isset($acc, act, pacman$Action.FRAME);
requires isset($acc, act, pacman$Action.DIRECTION);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, act, alloc);
ensures read($srcHeap, act, pacman$Action.DONEBY) == 0;
ensures !isset($acc, act, pacman$Action.DONEBY);
ensures read($srcHeap, act, pacman$Action.DIRECTION) == 0;
ensures !isset($acc, act, pacman$Action.DIRECTION);
ensures read($srcHeap, s, pacman$GameState.STATE) == 4;
ensures read($srcHeap, act, pacman$Action.FRAME) == 0;
ensures !isset($acc, act, pacman$Action.FRAME);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))
);

procedure ghostMoveLeft_apply(__trace__: ref,s: ref, rec: ref, ghost: ref, grid2: ref, grid1: ref, act: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_ghostMoveLeft($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),ghost),grid2),grid1),act));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 4;
requires read($srcHeap, act, pacman$Action.DONEBY) == 2;
requires read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	;
requires read($srcHeap, act, pacman$Action.DIRECTION) == 1;
// nac
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid1, pacman$Grid.hasEnemy);
requires isset($acc, grid1, pacman$Grid.left);
requires isset($acc, act, pacman$Action.DONEBY);
requires isset($acc, act, pacman$Action.FRAME);
requires isset($acc, act, pacman$Action.DIRECTION);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, act, alloc);
ensures read($srcHeap, act, pacman$Action.DONEBY) == 0;
ensures !isset($acc, act, pacman$Action.DONEBY);
ensures read($srcHeap, grid1, pacman$Grid.hasEnemy) == null;
ensures !isset($acc, grid1, pacman$Grid.hasEnemy);
ensures read($srcHeap, act, pacman$Action.DIRECTION) == 0;
ensures !isset($acc, act, pacman$Action.DIRECTION);
ensures read($srcHeap, s, pacman$GameState.STATE) == 5;
ensures read($srcHeap, act, pacman$Action.FRAME) == 0;
ensures !isset($acc, act, pacman$Action.FRAME);
ensures read($srcHeap, grid2, pacman$Grid.hasEnemy) == ghost;
ensures isset($acc, grid2, pacman$Grid.hasEnemy);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasEnemy))||
  (o == grid2 && ( f == pacman$Grid.hasEnemy))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasEnemy))||
  (o == grid2 && ( f == pacman$Grid.hasEnemy))
);

procedure ghostMoveRight_apply(__trace__: ref,s: ref, rec: ref, ghost: ref, grid2: ref, grid1: ref, act: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_ghostMoveRight($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),ghost),grid2),grid1),act));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 4;
requires read($srcHeap, act, pacman$Action.DONEBY) == 2;
requires read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	;
requires read($srcHeap, act, pacman$Action.DIRECTION) == 2;
// nac
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid1, pacman$Grid.hasEnemy);
requires isset($acc, grid1, pacman$Grid.right);
requires isset($acc, act, pacman$Action.DONEBY);
requires isset($acc, act, pacman$Action.FRAME);
requires isset($acc, act, pacman$Action.DIRECTION);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, act, alloc);
ensures read($srcHeap, act, pacman$Action.DONEBY) == 0;
ensures !isset($acc, act, pacman$Action.DONEBY);
ensures read($srcHeap, grid1, pacman$Grid.hasEnemy) == null;
ensures !isset($acc, grid1, pacman$Grid.hasEnemy);
ensures read($srcHeap, act, pacman$Action.DIRECTION) == 0;
ensures !isset($acc, act, pacman$Action.DIRECTION);
ensures read($srcHeap, s, pacman$GameState.STATE) == 5;
ensures read($srcHeap, act, pacman$Action.FRAME) == 0;
ensures !isset($acc, act, pacman$Action.FRAME);
ensures read($srcHeap, grid2, pacman$Grid.hasEnemy) == ghost;
ensures isset($acc, grid2, pacman$Grid.hasEnemy);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasEnemy))||
  (o == grid2 && ( f == pacman$Grid.hasEnemy))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasEnemy))||
  (o == grid2 && ( f == pacman$Grid.hasEnemy))
);

procedure ghostMoveTop_apply(__trace__: ref,s: ref, rec: ref, ghost: ref, grid2: ref, grid1: ref, act: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_ghostMoveTop($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),ghost),grid2),grid1),act));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 4;
requires read($srcHeap, act, pacman$Action.DONEBY) == 2;
requires read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	;
requires read($srcHeap, act, pacman$Action.DIRECTION) == 3;
// nac
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid1, pacman$Grid.hasEnemy);
requires isset($acc, grid1, pacman$Grid.top);
requires isset($acc, act, pacman$Action.DONEBY);
requires isset($acc, act, pacman$Action.FRAME);
requires isset($acc, act, pacman$Action.DIRECTION);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, act, alloc);
ensures read($srcHeap, act, pacman$Action.DONEBY) == 0;
ensures !isset($acc, act, pacman$Action.DONEBY);
ensures read($srcHeap, grid1, pacman$Grid.hasEnemy) == null;
ensures !isset($acc, grid1, pacman$Grid.hasEnemy);
ensures read($srcHeap, act, pacman$Action.DIRECTION) == 0;
ensures !isset($acc, act, pacman$Action.DIRECTION);
ensures read($srcHeap, s, pacman$GameState.STATE) == 5;
ensures read($srcHeap, act, pacman$Action.FRAME) == 0;
ensures !isset($acc, act, pacman$Action.FRAME);
ensures read($srcHeap, grid2, pacman$Grid.hasEnemy) == ghost;
ensures isset($acc, grid2, pacman$Grid.hasEnemy);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasEnemy))||
  (o == grid2 && ( f == pacman$Grid.hasEnemy))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasEnemy))||
  (o == grid2 && ( f == pacman$Grid.hasEnemy))
);

procedure ghostMoveBottom_apply(__trace__: ref,s: ref, rec: ref, ghost: ref, grid2: ref, grid1: ref, act: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_ghostMoveBottom($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),ghost),grid2),grid1),act));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 4;
requires read($srcHeap, act, pacman$Action.DONEBY) == 2;
requires read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	;
requires read($srcHeap, act, pacman$Action.DIRECTION) == 4;
// nac
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid1, pacman$Grid.hasEnemy);
requires isset($acc, grid1, pacman$Grid.bottom);
requires isset($acc, act, pacman$Action.DONEBY);
requires isset($acc, act, pacman$Action.FRAME);
requires isset($acc, act, pacman$Action.DIRECTION);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, act, alloc);
ensures read($srcHeap, act, pacman$Action.DONEBY) == 0;
ensures !isset($acc, act, pacman$Action.DONEBY);
ensures read($srcHeap, grid1, pacman$Grid.hasEnemy) == null;
ensures !isset($acc, grid1, pacman$Grid.hasEnemy);
ensures read($srcHeap, act, pacman$Action.DIRECTION) == 0;
ensures !isset($acc, act, pacman$Action.DIRECTION);
ensures read($srcHeap, s, pacman$GameState.STATE) == 5;
ensures read($srcHeap, act, pacman$Action.FRAME) == 0;
ensures !isset($acc, act, pacman$Action.FRAME);
ensures read($srcHeap, grid2, pacman$Grid.hasEnemy) == ghost;
ensures isset($acc, grid2, pacman$Grid.hasEnemy);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasEnemy))||
  (o == grid2 && ( f == pacman$Grid.hasEnemy))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid1 && ( f == pacman$Grid.hasEnemy))||
  (o == grid2 && ( f == pacman$Grid.hasEnemy))
);

procedure ghostStay_apply(__trace__: ref,s: ref, rec: ref, ghost: ref, grid1: ref, act: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_ghostStay($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),ghost),grid1),act));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 4;
requires read($srcHeap, act, pacman$Action.DONEBY) == 2;
requires read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	;
requires read($srcHeap, act, pacman$Action.DIRECTION) == 5;
// nac
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid1, pacman$Grid.hasEnemy);
requires isset($acc, act, pacman$Action.DONEBY);
requires isset($acc, act, pacman$Action.FRAME);
requires isset($acc, act, pacman$Action.DIRECTION);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, act, alloc);
ensures read($srcHeap, act, pacman$Action.DONEBY) == 0;
ensures !isset($acc, act, pacman$Action.DONEBY);
ensures read($srcHeap, act, pacman$Action.DIRECTION) == 0;
ensures !isset($acc, act, pacman$Action.DIRECTION);
ensures read($srcHeap, s, pacman$GameState.STATE) == 5;
ensures read($srcHeap, act, pacman$Action.FRAME) == 0;
ensures !isset($acc, act, pacman$Action.FRAME);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == act && ( f == pacman$Action.DONEBY|| f == pacman$Action.DIRECTION|| f == alloc|| f == pacman$Action.FRAME))||
  (o == s && ( f == pacman$GameState.STATE))
);

procedure Collect_apply(__trace__: ref,s: ref, rec: ref, pac: ref, gem: ref, grid: ref, recNew: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_Collect($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac),gem),grid));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 5;
// nac
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
requires isset($acc, grid, pacman$Grid.hasPlayer);
requires isset($acc, grid, pacman$Grid.hasGem);
// add elements are allocated with correct type
requires recNew != null && read($srcHeap, recNew, alloc);
requires (forall<alpha> f: Field alpha :: f!=alloc ==> !isset($acc, recNew, f));
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, rec, alloc);
ensures ! read($srcHeap, gem, alloc);
ensures read($srcHeap, grid, pacman$Grid.hasGem) == null;
ensures !isset($acc, grid, pacman$Grid.hasGem);
ensures read($srcHeap, s, pacman$GameState.record) == recNew;
ensures read($srcHeap, recNew, pacman$Record.SCORE) ==   read(old($srcHeap), rec, pacman$Record.SCORE)	+100 ;
ensures isset($acc, recNew, pacman$Record.SCORE);
ensures read($srcHeap, recNew, pacman$Record.FRAME) ==  read(old($srcHeap), rec, pacman$Record.FRAME)	;
ensures isset($acc, recNew, pacman$Record.FRAME);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == rec && ( f == alloc))||
  (o == s && ( f == pacman$GameState.record))||
  (o == recNew && ( f == pacman$Record.SCORE|| f == pacman$Record.FRAME))||
  (o == grid && ( f == pacman$Grid.hasGem))||
  (o == gem && ( f == alloc))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == rec && ( f == alloc))||
  (o == s && ( f == pacman$GameState.record))||
  (o == recNew && ( f == pacman$Record.SCORE|| f == pacman$Record.FRAME))||
  (o == grid && ( f == pacman$Grid.hasGem))||
  (o == gem && ( f == alloc))
);

procedure Kill_apply(__trace__: ref,s: ref, ghost: ref, pac: ref, grid: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_Kill($srcHeap), Seq#Build(Seq#Build(Seq#Build(Seq#Singleton(s),ghost),pac),grid));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 5;
// nac
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, grid, pacman$Grid.hasPlayer);
requires isset($acc, grid, pacman$Grid.hasEnemy);
// add elements are allocated with correct type
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, pac, alloc);
ensures read($srcHeap, grid, pacman$Grid.hasPlayer) == null;
ensures !isset($acc, grid, pacman$Grid.hasPlayer);
ensures read($srcHeap, s, pacman$GameState.STATE) == 6;
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == pac && ( f == alloc))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid && ( f == pacman$Grid.hasPlayer))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == pac && ( f == alloc))||
  (o == s && ( f == pacman$GameState.STATE))||
  (o == grid && ( f == pacman$Grid.hasPlayer))
);

procedure UpdateFrame_apply(__trace__: ref,s: ref, rec: ref, pac: ref, recNew: ref ) returns ();
// well_form inputs
requires well_formed($srcHeap, $acc);
// syntactic matching
requires Seq#Contains(findPatterns_UpdateFrame($srcHeap), Seq#Build(Seq#Build(Seq#Singleton(s),rec),pac));
// semantic matching
requires read($srcHeap, s, pacman$GameState.STATE) == 5;
// nac
// acc of structural/semantic matching
requires isset($acc, s, pacman$GameState.STATE);
requires isset($acc, s, pacman$GameState.record);
// add elements are allocated with correct type
requires recNew != null && read($srcHeap, recNew, alloc);
requires (forall<alpha> f: Field alpha :: f!=alloc ==> !isset($acc, recNew, f));
modifies $srcHeap, $acc;
ensures well_formed($srcHeap, $acc);
ensures ! read($srcHeap, rec, alloc);
ensures read($srcHeap, s, pacman$GameState.STATE) == 3;
ensures read($srcHeap, s, pacman$GameState.record) == recNew;
ensures read($srcHeap, recNew, pacman$Record.SCORE) ==  read(old($srcHeap), rec, pacman$Record.SCORE)	;
ensures isset($acc, recNew, pacman$Record.SCORE);
ensures read($srcHeap, recNew, pacman$Record.FRAME) ==   read(old($srcHeap), rec, pacman$Record.FRAME)	+1 ;
ensures isset($acc, recNew, pacman$Record.FRAME);
ensures (forall<alpha> o:ref,f:Field alpha::
  o!=null && read(old($srcHeap),o,alloc) ==> 
  (read($srcHeap,o,f)==read(old($srcHeap),o,f)) ||
  (o == rec && ( f == alloc))||
  (o == s && ( f == pacman$GameState.STATE|| f == pacman$GameState.record))||
  (o == recNew && ( f == pacman$Record.SCORE|| f == pacman$Record.FRAME))
);
ensures (forall<alpha> o:ref,f:Field alpha::
  (isset($acc,o,f)==isset(old($acc),o,f)) ||
  (o == rec && ( f == alloc))||
  (o == s && ( f == pacman$GameState.STATE|| f == pacman$GameState.record))||
  (o == recNew && ( f == pacman$Record.SCORE|| f == pacman$Record.FRAME))
);

