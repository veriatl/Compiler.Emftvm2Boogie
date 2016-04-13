
implementation ghostMoveBottom_match(s: ref,rec: ref,ghost: ref,grid2: ref,grid1: ref,act: ref) returns (r: bool)
{

var stk: Seq BoxType;
var $newCol: ref;
var obj#3: bool;
var cond#4: bool;
var obj#8: bool;
var cond#11: bool;
var obj#16: bool;
var cond#19: bool;
var obj#23: bool;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, s);
//1: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$GameState.STATE)));

call stk := OpCode#PUSHI(stk, 4);
//3: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
cond#4 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#4){goto label_10;}
label_5:
//5: LOAD 
call stk := OpCode#LOAD(stk, act);
//6: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$Action.DONEBY)));

call stk := OpCode#PUSHI(stk, 2);
//8: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
goto label_11;
label_10:
call stk := OpCode#PUSHF(stk);
label_11:
cond#11 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#11){goto label_18;}
label_12:
//12: LOAD 
call stk := OpCode#LOAD(stk, act);
//13: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$Action.FRAME)));

//14: LOAD 
call stk := OpCode#LOAD(stk, rec);
//15: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$Record.FRAME)));

//16: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
goto label_19;
label_18:
call stk := OpCode#PUSHF(stk);
label_19:
cond#19 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#19){goto label_25;}
label_20:
//20: LOAD 
call stk := OpCode#LOAD(stk, act);
//21: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$Action.DIRECTION)));

call stk := OpCode#PUSHI(stk, 4);
//23: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
goto label_26;
label_25:
call stk := OpCode#PUSHF(stk);
label_26:
label_END_rule_ghostMoveBottom_matcher:
r:=$Unbox(top(stk));

}
