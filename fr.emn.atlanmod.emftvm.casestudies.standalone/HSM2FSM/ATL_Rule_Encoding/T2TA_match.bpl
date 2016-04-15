
implementation T2TA_match(t1: ref) returns (r: bool)
{

var stk: Seq BoxType;
var $newCol: ref;
var obj#3: bool;
var cond#5: bool;
var obj#9: bool;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, t1);
//1: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),HSM$Transition.source)));

call stk := OpCode#FINDTYPE(stk, _HSM, _CompositeState);
//3: INVOKE 
call stk := OCLAny#IsTypeof(stk);
call stk := OpCode#NOT(stk);
cond#5 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#5){goto label_12;}
label_6:
//6: LOAD 
call stk := OpCode#LOAD(stk, t1);
//7: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),HSM$Transition.target)));

call stk := OpCode#FINDTYPE(stk, _HSM, _CompositeState);
//9: INVOKE 
call stk := OCLAny#IsTypeof(stk);
call stk := OpCode#NOT(stk);
goto label_13;
label_12:
call stk := OpCode#PUSHF(stk);
label_13:
label_END_rule_T2TA_matcher:
r:=$Unbox(top(stk));

}
