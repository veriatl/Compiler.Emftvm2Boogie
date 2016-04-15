
implementation IS2IS_match(is1: ref) returns (r: bool)
{

var stk: Seq BoxType;
var $newCol: ref;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, is1);
//1: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),HSM$AbstractState.compositeState)));

call stk := OpCode#ISNULL(stk);
label_END_rule_IS2IS_matcher:
r:=$Unbox(top(stk));

}
