
implementation Collect_apply (__trace__: ref,s: ref,rec: ref,pac: ref,gem: ref,grid: ref,recNew: ref) returns ()
{

var stk: Seq BoxType;
var $newCol: ref;
var obj#17: bool;
var heap#20: HeapType;
var heap#22: HeapType;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, s);
//1: LOAD 
call stk := OpCode#LOAD(stk, rec);
//2: REMOVE 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
if(read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.record) == $Unbox(Seq#Index(stk, Seq#Length(stk)-1))){
assert isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.record);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.record, null);
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.record, false);
}
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//3: LOAD 
call stk := OpCode#LOAD(stk, grid);
//4: LOAD 
call stk := OpCode#LOAD(stk, gem);
//5: REMOVE 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
if(read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasGem) == $Unbox(Seq#Index(stk, Seq#Length(stk)-1))){
assert isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasGem);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasGem, null);
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Grid.hasGem, false);
}
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//6: LOAD 
call stk := OpCode#LOAD(stk, s);
//7: LOAD 
call stk := OpCode#LOAD(stk, recNew);
//8: ADD 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
assert !isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.record);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.record, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.record, true);
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//9: LOAD 
call stk := OpCode#LOAD(stk, recNew);
//10: LOAD 
call stk := OpCode#LOAD(stk, rec);
//11: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$Record.FRAME)));

//12: ADD 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
assert !isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.FRAME);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.FRAME, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.FRAME, true);
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//13: LOAD 
call stk := OpCode#LOAD(stk, recNew);
//14: LOAD 
call stk := OpCode#LOAD(stk, rec);
//15: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$Record.SCORE)));

call stk := OpCode#PUSHI(stk, 100);
//17: INVOKE 
call stk := OCL#Integer#ADD(stk);
//18: ADD 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
assert !isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.SCORE);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.SCORE, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.SCORE, true);
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//19: LOAD 
call stk := OpCode#LOAD(stk, rec);
//20: DELETE 
assert Seq#Length(stk) > 0;
heap#20 := $srcHeap;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1))!=null && read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), alloc);
havoc $srcHeap;
assume (forall<alpha> r: ref, f: Field alpha :: r != null && read(heap#20, r, alloc) && r!=$Unbox(Seq#Index(stk, Seq#Length(stk)-1)) ==> read($srcHeap, r, f) == read(heap#20 , r, f));
assume (forall<alpha> r: ref, f: Field alpha :: r != null && !read(heap#20, r, alloc) ==> read($srcHeap, r, f) == read(heap#20 , r, f));
assume (forall<alpha> f: Field alpha :: f!=alloc ==> read(heap#20, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), f) == read($srcHeap , $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), f));
assume !read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), alloc);
stk := Seq#Take(stk, Seq#Length(stk)-1);

//21: LOAD 
call stk := OpCode#LOAD(stk, gem);
//22: DELETE 
assert Seq#Length(stk) > 0;
heap#22 := $srcHeap;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1))!=null && read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), alloc);
havoc $srcHeap;
assume (forall<alpha> r: ref, f: Field alpha :: r != null && read(heap#22, r, alloc) && r!=$Unbox(Seq#Index(stk, Seq#Length(stk)-1)) ==> read($srcHeap, r, f) == read(heap#22 , r, f));
assume (forall<alpha> r: ref, f: Field alpha :: r != null && !read(heap#22, r, alloc) ==> read($srcHeap, r, f) == read(heap#22 , r, f));
assume (forall<alpha> f: Field alpha :: f!=alloc ==> read(heap#22, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), f) == read($srcHeap , $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), f));
assume !read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), alloc);
stk := Seq#Take(stk, Seq#Length(stk)-1);

label_END_rule_Collect_applier:

}
