
implementation RA2A_match(att: ref,rs: ref) returns (r: bool)
{

var stk: Seq BoxType;
var $newCol: ref;
var obj#3: bool;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, att);
//1: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),ER$ERAttribute.relship)));

//2: LOAD 
call stk := OpCode#LOAD(stk, rs);
//3: INVOKE 
call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ref,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
label_END_rule_RA2A_matcher:
r:=$Unbox(top(stk));

}
