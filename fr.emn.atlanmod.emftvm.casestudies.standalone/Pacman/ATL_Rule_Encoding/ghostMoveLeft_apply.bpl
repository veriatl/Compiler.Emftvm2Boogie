
implementation ghostMoveLeft_apply (__trace__: ref,s: ref,rec: ref,ghost: ref,grid2: ref,grid1: ref,act: ref) returns ()
{

var stk: Seq BoxType;
var $newCol: ref;
var heap#23: HeapType;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, s);
call stk := OpCode#PUSHI(stk, 4);
//2: REMOVE 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
if(read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.STATE) == $Unbox(Seq#Index(stk, Seq#Length(stk)-1))){
assert isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.STATE);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.STATE, 0);
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.STATE, false);
}
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//3: LOAD 
call stk := OpCode#LOAD(stk, grid1);
//4: LOAD 
call stk := OpCode#LOAD(stk, ghost);
//5: REMOVE 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
if(read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasEnemy) == $Unbox(Seq#Index(stk, Seq#Length(stk)-1))){
assert isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasEnemy);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasEnemy, null);
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasEnemy, false);
}
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//6: LOAD 
call stk := OpCode#LOAD(stk, act);
call stk := OpCode#PUSHI(stk, 2);
//8: REMOVE 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
if(read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.DONEBY) == $Unbox(Seq#Index(stk, Seq#Length(stk)-1))){
assert isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.DONEBY);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.DONEBY, 0);
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.DONEBY, false);
}
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//9: LOAD 
call stk := OpCode#LOAD(stk, act);
//10: LOAD 
call stk := OpCode#LOAD(stk, rec);
//11: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$Record.FRAME)));

//12: REMOVE 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
if(read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.FRAME) == $Unbox(Seq#Index(stk, Seq#Length(stk)-1))){
assert isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.FRAME);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.FRAME, 0);
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.FRAME, false);
}
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//13: LOAD 
call stk := OpCode#LOAD(stk, act);
call stk := OpCode#PUSHI(stk, 1);
//15: REMOVE 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
if(read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.DIRECTION) == $Unbox(Seq#Index(stk, Seq#Length(stk)-1))){
assert isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.DIRECTION);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.DIRECTION, 0);
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Action.DIRECTION, false);
}
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//16: LOAD 
call stk := OpCode#LOAD(stk, s);
call stk := OpCode#PUSHI(stk, 5);
//18: ADD 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
assert !isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.STATE);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.STATE, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.STATE, true);
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//19: LOAD 
call stk := OpCode#LOAD(stk, grid2);
//20: LOAD 
call stk := OpCode#LOAD(stk, ghost);
//21: ADD 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
assert !isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasEnemy);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasEnemy, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasEnemy, true);
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//22: LOAD 
call stk := OpCode#LOAD(stk, act);
//23: DELETE 
assert Seq#Length(stk) > 0;
heap#23 := $srcHeap;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1))!=null && read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), alloc);
havoc $srcHeap;
assume (forall<alpha> r: ref, f: Field alpha :: r != null && read(heap#23, r, alloc) && r!=$Unbox(Seq#Index(stk, Seq#Length(stk)-1)) ==> read($srcHeap, r, f) == read(heap#23 , r, f));
assume (forall<alpha> r: ref, f: Field alpha :: r != null && !read(heap#23, r, alloc) ==> read($srcHeap, r, f) == read(heap#23 , r, f));
assume (forall<alpha> f: Field alpha :: f!=alloc ==> read(heap#23, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), f) == read($srcHeap , $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), f));
assume !read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), alloc);
stk := Seq#Take(stk, Seq#Length(stk)-1);

label_END_rule_ghostMoveLeft_applier:

}
