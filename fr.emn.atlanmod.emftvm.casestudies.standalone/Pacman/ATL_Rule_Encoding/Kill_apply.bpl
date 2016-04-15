
implementation Kill_apply (__trace__: ref,s: ref,ghost: ref,pac: ref,grid: ref) returns ()
{

var stk: Seq BoxType;
var $newCol: ref;
var heap#10: HeapType;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, s);
call stk := OpCode#PUSHI(stk, 5);
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
call stk := OpCode#LOAD(stk, grid);
//4: LOAD 
call stk := OpCode#LOAD(stk, pac);
//5: REMOVE 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
if(read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasPlayer) == $Unbox(Seq#Index(stk, Seq#Length(stk)-1))){
assert isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasPlayer);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasPlayer, null);
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasPlayer, false);
}
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//6: LOAD 
call stk := OpCode#LOAD(stk, s);
call stk := OpCode#PUSHI(stk, 6);
//8: ADD 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
assert !isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.STATE);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.STATE, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.STATE, true);
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//9: LOAD 
call stk := OpCode#LOAD(stk, pac);
//10: DELETE 
assert Seq#Length(stk) > 0;
heap#10 := $srcHeap;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1))!=null && read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), alloc);
havoc $srcHeap;
assume (forall<alpha> r: ref, f: Field alpha :: r != null && read(heap#10, r, alloc) && r!=$Unbox(Seq#Index(stk, Seq#Length(stk)-1)) ==> read($srcHeap, r, f) == read(heap#10 , r, f));
assume (forall<alpha> r: ref, f: Field alpha :: r != null && !read(heap#10, r, alloc) ==> read($srcHeap, r, f) == read(heap#10 , r, f));
assume (forall<alpha> f: Field alpha :: f!=alloc ==> read(heap#10, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), f) == read($srcHeap , $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), f));
assume !read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), alloc);
stk := Seq#Take(stk, Seq#Length(stk)-1);

label_END_rule_Kill_applier:

}
