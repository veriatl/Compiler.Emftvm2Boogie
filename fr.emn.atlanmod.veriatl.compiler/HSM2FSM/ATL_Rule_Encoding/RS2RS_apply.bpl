
implementation RS2RS_apply (__trace__: ref,rs1: ref,rs2: ref) returns ()
{

var stk: Seq BoxType;
var $newCol: ref;
var obj#3: bool;
var obj#8: bool;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, rs2);
//1: LOAD 
call stk := OpCode#LOAD(stk, rs1);
//2: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),HSM$AbstractState.name)));

//3: INVOKE 
call stk := EMFTVM#Resolve(stk, $srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)): String);
//4: SET 
assert Seq#Length(stk) >= 2;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
$tarHeap := update($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)),FSM$AbstractState.name,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
assume $IsGoodHeap($tarHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//5: LOAD 
call stk := OpCode#LOAD(stk, rs2);
//6: LOAD 
call stk := OpCode#LOAD(stk, rs1);
//7: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),HSM$AbstractState.stateMachine)));

//8: INVOKE 
call stk := EMFTVM#Resolve(stk, $srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
//9: SET 
assert Seq#Length(stk) >= 2;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
$tarHeap := update($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)),FSM$AbstractState.stateMachine,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
assume $IsGoodHeap($tarHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

label_END_rule_RS2RS_applier:

}
