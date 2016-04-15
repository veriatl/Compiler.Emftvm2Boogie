
implementation UpdateFrame_apply (__trace__: ref,s: ref,rec: ref,pac: ref,recNew: ref) returns ()
{

var stk: Seq BoxType;
var $newCol: ref;
var obj#16: bool;
var heap#23: HeapType;
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
call stk := OpCode#LOAD(stk, s);
//4: LOAD 
call stk := OpCode#LOAD(stk, rec);
//5: REMOVE 
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

//6: LOAD 
call stk := OpCode#LOAD(stk, s);
call stk := OpCode#PUSHI(stk, 3);
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
call stk := OpCode#LOAD(stk, s);
//10: LOAD 
call stk := OpCode#LOAD(stk, recNew);
//11: ADD 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
assert !isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.record);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.record, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$GameState.record, true);
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//12: LOAD 
call stk := OpCode#LOAD(stk, recNew);
//13: LOAD 
call stk := OpCode#LOAD(stk, rec);
//14: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$Record.FRAME)));

call stk := OpCode#PUSHI(stk, 1);
//16: INVOKE 
call stk := OCL#Integer#ADD(stk);
//17: ADD 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
assert !isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.FRAME);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.FRAME, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.FRAME, true);
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//18: LOAD 
call stk := OpCode#LOAD(stk, recNew);
//19: LOAD 
call stk := OpCode#LOAD(stk, rec);
//20: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$Record.SCORE)));

//21: ADD 
assert Seq#Length(stk) > 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
assert !isset($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.SCORE);
$srcHeap := update($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.SCORE, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
$acc := set($acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), pacman$Record.SCORE, true);
assume $IsGoodHeap($srcHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//22: LOAD 
call stk := OpCode#LOAD(stk, rec);
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

label_END_rule_UpdateFrame_applier:

}
