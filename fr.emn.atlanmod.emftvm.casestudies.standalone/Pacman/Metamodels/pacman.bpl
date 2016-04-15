
const unique pacman$GameState: ClassName extends  complete;
	
const unique pacman$GameState.grids: Field ref;

const unique pacman$GameState.actions: Field ref;

const unique pacman$GameState.player: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$GameState ==> !(dtype(read(_hp,o,pacman$GameState.player))<:#native$Collection ));

const unique pacman$GameState.ghost: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$GameState ==> !(dtype(read(_hp,o,pacman$GameState.ghost))<:#native$Collection ));

const unique pacman$GameState.gems: Field ref;

const unique pacman$GameState.MAXFRAME: Field int;
const unique pacman$GameState.record: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$GameState ==> !(dtype(read(_hp,o,pacman$GameState.record))<:#native$Collection ));

const unique pacman$GameState.STATE: Field int;

const unique pacman$Pacman: ClassName extends  complete;
	

const unique pacman$Grid: ClassName extends  complete;
	
const unique pacman$Grid.left: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$Grid ==> !(dtype(read(_hp,o,pacman$Grid.left))<:#native$Collection ));

const unique pacman$Grid.right: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$Grid ==> !(dtype(read(_hp,o,pacman$Grid.right))<:#native$Collection ));

const unique pacman$Grid.top: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$Grid ==> !(dtype(read(_hp,o,pacman$Grid.top))<:#native$Collection ));

const unique pacman$Grid.bottom: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$Grid ==> !(dtype(read(_hp,o,pacman$Grid.bottom))<:#native$Collection ));

const unique pacman$Grid.hasPlayer: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$Grid ==> !(dtype(read(_hp,o,pacman$Grid.hasPlayer))<:#native$Collection ));

const unique pacman$Grid.hasEnemy: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$Grid ==> !(dtype(read(_hp,o,pacman$Grid.hasEnemy))<:#native$Collection ));

const unique pacman$Grid.hasGem: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$Grid ==> !(dtype(read(_hp,o,pacman$Grid.hasGem))<:#native$Collection ));


const unique pacman$Ghost: ClassName extends  complete;
	

const unique pacman$Action: ClassName extends  complete;
	
const unique pacman$Action.FRAME: Field int;
const unique pacman$Action.forPlayer: Field ref;

axiom (forall _hp: HeapType, o: ref :: o!=null && read(_hp, o, alloc) && dtype(o) <: pacman$Action ==> !(dtype(read(_hp,o,pacman$Action.forPlayer))<:#native$Collection ));

const unique pacman$Action.DONEBY: Field int;
const unique pacman$Action.DIRECTION: Field int;

const unique pacman$Gem: ClassName extends  complete;
	

const unique pacman$Record: ClassName extends  complete;
	
const unique pacman$Record.FRAME: Field int;
const unique pacman$Record.SCORE: Field int;

