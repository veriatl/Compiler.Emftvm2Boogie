
implementation T2TB_match(t1: ref,src: ref,trg: ref,c: ref) returns (r: bool)
{

var stk: Seq BoxType;
var $newCol: ref;
var obj#3: bool;
var cond#4: bool;
var obj#8: bool;
var cond#11: bool;
var obj#15: bool;
var cond#18: bool;
var obj#21: bool;
var cond#25: bool;
var obj#28: bool;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, t1);
//1: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),HSM$Transition.source)));

//2: LOAD 
call stk := OpCode#LOAD(stk, src);
//3: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
cond#4 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#4){goto label_10;}
label_5:
//5: LOAD 
call stk := OpCode#LOAD(stk, t1);
//6: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),HSM$Transition.target)));

//7: LOAD 
call stk := OpCode#LOAD(stk, trg);
//8: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
goto label_11;
label_10:
call stk := OpCode#PUSHF(stk);
label_11:
cond#11 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#11){goto label_17;}
label_12:
//12: LOAD 
call stk := OpCode#LOAD(stk, c);
//13: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),HSM$AbstractState.compositeState)));

//14: LOAD 
call stk := OpCode#LOAD(stk, src);
//15: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
goto label_18;
label_17:
call stk := OpCode#PUSHF(stk);
label_18:
cond#18 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#18){goto label_24;}
label_19:
//19: LOAD 
call stk := OpCode#LOAD(stk, trg);
call stk := OpCode#FINDTYPE(stk, _HSM, _CompositeState);
//21: INVOKE 
call stk := OCLAny#IsTypeof(stk);
call stk := OpCode#NOT(stk);
goto label_25;
label_24:
call stk := OpCode#PUSHF(stk);
label_25:
cond#25 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#25){goto label_31;}
label_26:
//26: LOAD 
call stk := OpCode#LOAD(stk, c);
//27: LOAD 
call stk := OpCode#LOAD(stk, src);
//28: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
call stk := OpCode#NOT(stk);
goto label_32;
label_31:
call stk := OpCode#PUSHF(stk);
label_32:
label_END_rule_T2TB_matcher:
r:=$Unbox(top(stk));

}
