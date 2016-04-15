
implementation PlayerMoveTop_match(s: ref,rec: ref,pac: ref,grid2: ref,grid1: ref,act: ref,ghost: ref) returns (r: bool)
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
var cond#26: bool;
var obj#31: bool;
var cond#32: bool;
var obj#32: Seq ref;
var $counter#33: int;
var decreases#33: int;
var obj#35: bool;
var cond#36: bool;
var obj#44: bool;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, s);
//1: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$GameState.STATE)));

call stk := OpCode#PUSHI(stk, 3);
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

call stk := OpCode#PUSHI(stk, 1);
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

call stk := OpCode#PUSHI(stk, 3);
//23: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
goto label_26;
label_25:
call stk := OpCode#PUSHF(stk);
label_26:
cond#26 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#26){goto label_47;}
label_27:
//27: LOAD 
call stk := OpCode#LOAD(stk, grid2);
//28: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),pacman$Grid.hasEnemy)));

call stk := OpCode#DUP(stk);
call stk := OpCode#FINDTYPE(stk, _#native, _Collection);
//31: INVOKE 
call stk := OCLAny#IsKindof(stk);
cond#32 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#32){goto label_43;}
label_33:
//33: ITERATE 
obj#32 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
$counter#33:=0;
call stk := OpCode#POP(stk);
while($counter#33<Seq#Length(obj#32)) 
{stk := Seq#Build(stk, $Box(Seq#Index(obj#32, $counter#33)));
call stk := OpCode#FINDTYPE(stk, _pacman, _Ghost);
//35: INVOKE 
call stk := OCLAny#IsKindof(stk);
cond#36 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(cond#36){goto label_40;}
label_37:
//37: ENDITERATE 
$counter#33 := $counter#33+1;
}
call stk := OpCode#PUSHF(stk);
goto label_45;
label_40:
call stk := OpCode#POP(stk);
call stk := OpCode#PUSHT(stk);
goto label_45;
label_43:
call stk := OpCode#FINDTYPE(stk, _pacman, _Ghost);
//44: INVOKE 
call stk := OCLAny#IsKindof(stk);
label_45:
call stk := OpCode#NOT(stk);
goto label_48;
label_47:
call stk := OpCode#PUSHF(stk);
label_48:
label_END_rule_PlayerMoveTop_matcher:
r:=$Unbox(top(stk));

}
