
implementation RA2AK_match(att: ref,rse: ref) returns (r: bool)
{

var stk: Seq BoxType;
var $newCol: ref;
var obj#4: bool;
var cond#5: bool;
var obj#9: bool;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, att);
//1: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),ER$ERAttribute.entity)));

//2: LOAD 
call stk := OpCode#LOAD(stk, rse);
//3: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),ER$RelshipEnd.entity)));

//4: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
cond#5 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(!cond#5){goto label_11;}
label_6:
//6: LOAD 
call stk := OpCode#LOAD(stk, att);
//7: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),ER$ERAttribute.isKey)));

call stk := OpCode#PUSHT(stk);
//9: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
goto label_12;
label_11:
call stk := OpCode#PUSHF(stk);
label_12:
label_END_rule_RA2AK_matcher:
r:=$Unbox(top(stk));

}
