procedure PlayerMoveLeft_match(s: ref, rec: ref, pac: ref, grid2: ref, grid1: ref, act: ref, ghost: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires pac != null && read($srcHeap, pac, alloc) && dtype(pac) <: pacman$Pacman;
requires grid2 != null && read($srcHeap, grid2, alloc) && dtype(grid2) <: pacman$Grid;
requires grid1 != null && read($srcHeap, grid1, alloc) && dtype(grid1) <: pacman$Grid;
requires act != null && read($srcHeap, act, alloc) && dtype(act) <: pacman$Action;
//injective matching
requires grid2 != grid1;
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid1, pacman$Grid.hasPlayer) == pac;
requires read($srcHeap, grid1, pacman$Grid.left) == grid2;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 3
&& read($srcHeap, act, pacman$Action.DONEBY) == 1
&& read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	
&& read($srcHeap, act, pacman$Action.DIRECTION) == 1
&& !(dtype(read($srcHeap, grid2, pacman$Grid.hasEnemy)) <: pacman$Ghost)
);

procedure PlayerMoveRight_match(s: ref, rec: ref, pac: ref, grid2: ref, grid1: ref, act: ref, ghost: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires pac != null && read($srcHeap, pac, alloc) && dtype(pac) <: pacman$Pacman;
requires grid2 != null && read($srcHeap, grid2, alloc) && dtype(grid2) <: pacman$Grid;
requires grid1 != null && read($srcHeap, grid1, alloc) && dtype(grid1) <: pacman$Grid;
requires act != null && read($srcHeap, act, alloc) && dtype(act) <: pacman$Action;
//injective matching
requires grid2 != grid1;
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid1, pacman$Grid.hasPlayer) == pac;
requires read($srcHeap, grid1, pacman$Grid.right) == grid2;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 3
&& read($srcHeap, act, pacman$Action.DONEBY) == 1
&& read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	
&& read($srcHeap, act, pacman$Action.DIRECTION) == 2
&& !(dtype(read($srcHeap, grid2, pacman$Grid.hasEnemy)) <: pacman$Ghost)
);

procedure PlayerMoveTop_match(s: ref, rec: ref, pac: ref, grid2: ref, grid1: ref, act: ref, ghost: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires pac != null && read($srcHeap, pac, alloc) && dtype(pac) <: pacman$Pacman;
requires grid2 != null && read($srcHeap, grid2, alloc) && dtype(grid2) <: pacman$Grid;
requires grid1 != null && read($srcHeap, grid1, alloc) && dtype(grid1) <: pacman$Grid;
requires act != null && read($srcHeap, act, alloc) && dtype(act) <: pacman$Action;
//injective matching
requires grid2 != grid1;
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid1, pacman$Grid.hasPlayer) == pac;
requires read($srcHeap, grid1, pacman$Grid.top) == grid2;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 3
&& read($srcHeap, act, pacman$Action.DONEBY) == 1
&& read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	
&& read($srcHeap, act, pacman$Action.DIRECTION) == 3
&& !(dtype(read($srcHeap, grid2, pacman$Grid.hasEnemy)) <: pacman$Ghost)
);

procedure PlayerMoveBottom_match(s: ref, rec: ref, pac: ref, grid2: ref, grid1: ref, act: ref, ghost: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires pac != null && read($srcHeap, pac, alloc) && dtype(pac) <: pacman$Pacman;
requires grid2 != null && read($srcHeap, grid2, alloc) && dtype(grid2) <: pacman$Grid;
requires grid1 != null && read($srcHeap, grid1, alloc) && dtype(grid1) <: pacman$Grid;
requires act != null && read($srcHeap, act, alloc) && dtype(act) <: pacman$Action;
//injective matching
requires grid2 != grid1;
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid1, pacman$Grid.hasPlayer) == pac;
requires read($srcHeap, grid1, pacman$Grid.bottom) == grid2;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 3
&& read($srcHeap, act, pacman$Action.DONEBY) == 1
&& read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	
&& read($srcHeap, act, pacman$Action.DIRECTION) == 4
&& !(dtype(read($srcHeap, grid2, pacman$Grid.hasEnemy)) <: pacman$Ghost)
);

procedure PlayerStay_match(s: ref, rec: ref, pac: ref, grid1: ref, act: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires pac != null && read($srcHeap, pac, alloc) && dtype(pac) <: pacman$Pacman;
requires grid1 != null && read($srcHeap, grid1, alloc) && dtype(grid1) <: pacman$Grid;
requires act != null && read($srcHeap, act, alloc) && dtype(act) <: pacman$Action;
//injective matching
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid1, pacman$Grid.hasPlayer) == pac;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 3
&& read($srcHeap, act, pacman$Action.DONEBY) == 1
&& read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	
&& read($srcHeap, act, pacman$Action.DIRECTION) == 5
);

procedure ghostMoveLeft_match(s: ref, rec: ref, ghost: ref, grid2: ref, grid1: ref, act: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires ghost != null && read($srcHeap, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
requires grid2 != null && read($srcHeap, grid2, alloc) && dtype(grid2) <: pacman$Grid;
requires grid1 != null && read($srcHeap, grid1, alloc) && dtype(grid1) <: pacman$Grid;
requires act != null && read($srcHeap, act, alloc) && dtype(act) <: pacman$Action;
//injective matching
requires grid2 != grid1;
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid1, pacman$Grid.hasEnemy) == ghost;
requires read($srcHeap, grid1, pacman$Grid.left) == grid2;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 4
&& read($srcHeap, act, pacman$Action.DONEBY) == 2
&& read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	
&& read($srcHeap, act, pacman$Action.DIRECTION) == 1
);

procedure ghostMoveRight_match(s: ref, rec: ref, ghost: ref, grid2: ref, grid1: ref, act: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires ghost != null && read($srcHeap, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
requires grid2 != null && read($srcHeap, grid2, alloc) && dtype(grid2) <: pacman$Grid;
requires grid1 != null && read($srcHeap, grid1, alloc) && dtype(grid1) <: pacman$Grid;
requires act != null && read($srcHeap, act, alloc) && dtype(act) <: pacman$Action;
//injective matching
requires grid2 != grid1;
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid1, pacman$Grid.hasEnemy) == ghost;
requires read($srcHeap, grid1, pacman$Grid.right) == grid2;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 4
&& read($srcHeap, act, pacman$Action.DONEBY) == 2
&& read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	
&& read($srcHeap, act, pacman$Action.DIRECTION) == 2
);

procedure ghostMoveTop_match(s: ref, rec: ref, ghost: ref, grid2: ref, grid1: ref, act: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires ghost != null && read($srcHeap, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
requires grid2 != null && read($srcHeap, grid2, alloc) && dtype(grid2) <: pacman$Grid;
requires grid1 != null && read($srcHeap, grid1, alloc) && dtype(grid1) <: pacman$Grid;
requires act != null && read($srcHeap, act, alloc) && dtype(act) <: pacman$Action;
//injective matching
requires grid2 != grid1;
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid1, pacman$Grid.hasEnemy) == ghost;
requires read($srcHeap, grid1, pacman$Grid.top) == grid2;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 4
&& read($srcHeap, act, pacman$Action.DONEBY) == 2
&& read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	
&& read($srcHeap, act, pacman$Action.DIRECTION) == 3
);

procedure ghostMoveBottom_match(s: ref, rec: ref, ghost: ref, grid2: ref, grid1: ref, act: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires ghost != null && read($srcHeap, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
requires grid2 != null && read($srcHeap, grid2, alloc) && dtype(grid2) <: pacman$Grid;
requires grid1 != null && read($srcHeap, grid1, alloc) && dtype(grid1) <: pacman$Grid;
requires act != null && read($srcHeap, act, alloc) && dtype(act) <: pacman$Action;
//injective matching
requires grid2 != grid1;
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid1, pacman$Grid.hasEnemy) == ghost;
requires read($srcHeap, grid1, pacman$Grid.bottom) == grid2;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 4
&& read($srcHeap, act, pacman$Action.DONEBY) == 2
&& read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	
&& read($srcHeap, act, pacman$Action.DIRECTION) == 4
);

procedure ghostStay_match(s: ref, rec: ref, ghost: ref, grid1: ref, act: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires ghost != null && read($srcHeap, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
requires grid1 != null && read($srcHeap, grid1, alloc) && dtype(grid1) <: pacman$Grid;
requires act != null && read($srcHeap, act, alloc) && dtype(act) <: pacman$Action;
//injective matching
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid1, pacman$Grid.hasEnemy) == ghost;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 4
&& read($srcHeap, act, pacman$Action.DONEBY) == 2
&& read($srcHeap, act, pacman$Action.FRAME) ==  read($srcHeap, rec, pacman$Record.FRAME)	
&& read($srcHeap, act, pacman$Action.DIRECTION) == 5
);

procedure Collect_match(s: ref, rec: ref, pac: ref, gem: ref, grid: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires pac != null && read($srcHeap, pac, alloc) && dtype(pac) <: pacman$Pacman;
requires gem != null && read($srcHeap, gem, alloc) && dtype(gem) <: pacman$Gem;
requires grid != null && read($srcHeap, grid, alloc) && dtype(grid) <: pacman$Grid;
//injective matching
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
requires read($srcHeap, grid, pacman$Grid.hasPlayer) == pac;
requires read($srcHeap, grid, pacman$Grid.hasGem) == gem;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 5
);

procedure Kill_match(s: ref, ghost: ref, pac: ref, grid: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires ghost != null && read($srcHeap, ghost, alloc) && dtype(ghost) <: pacman$Ghost;
requires pac != null && read($srcHeap, pac, alloc) && dtype(pac) <: pacman$Pacman;
requires grid != null && read($srcHeap, grid, alloc) && dtype(grid) <: pacman$Grid;
//injective matching
// structural matching
requires read($srcHeap, grid, pacman$Grid.hasPlayer) == pac;
requires read($srcHeap, grid, pacman$Grid.hasEnemy) == ghost;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 5
);

procedure UpdateFrame_match(s: ref, rec: ref, pac: ref) returns (r: bool);
// alloc
requires s != null && read($srcHeap, s, alloc) && dtype(s) <: pacman$GameState;
requires rec != null && read($srcHeap, rec, alloc) && dtype(rec) <: pacman$Record;
requires pac != null && read($srcHeap, pac, alloc) && dtype(pac) <: pacman$Pacman;
//injective matching
// structural matching
requires read($srcHeap, s, pacman$GameState.record) == rec;
ensures r <==> (
true
&& read($srcHeap, s, pacman$GameState.STATE) == 5
);

