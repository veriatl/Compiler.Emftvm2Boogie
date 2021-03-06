
implementation RA2A_apply (__trace__: ref,att: ref,rs: ref,t: ref) returns ()
{

var stk: Seq BoxType;
var $newCol: ref;
var obj#3: bool;
var obj#8: bool;
var obj#12: bool;
stk := OpCode#Aux#InitStk();

//0: LOAD 
call stk := OpCode#LOAD(stk, t);
//1: LOAD 
call stk := OpCode#LOAD(stk, att);
//2: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),ER$ERAttribute.name)));

//3: INVOKE 
call stk := EMFTVM#Resolve(stk, $srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)): String);
//4: SET 
assert Seq#Length(stk) >= 2;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
$tarHeap := update($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)),REL$RELAttribute.name,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
assume $IsGoodHeap($tarHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//5: LOAD 
call stk := OpCode#LOAD(stk, t);
//6: LOAD 
call stk := OpCode#LOAD(stk, att);
//7: GET 
assert Seq#Length(stk) >= 1;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
assert read($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($srcHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)),ER$ERAttribute.isKey)));

//8: INVOKE 
call stk := EMFTVM#Resolve(stk, $srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)): bool);
//9: SET 
assert Seq#Length(stk) >= 2;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
$tarHeap := update($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)),REL$RELAttribute.isKey,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
assume $IsGoodHeap($tarHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

//10: LOAD 
call stk := OpCode#LOAD(stk, t);
//11: LOAD 
call stk := OpCode#LOAD(stk, rs);
//12: INVOKE 
call stk := EMFTVM#Resolve(stk, $srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ref);
//13: SET 
assert Seq#Length(stk) >= 2;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
assert read($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
$tarHeap := update($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)),REL$RELAttribute.relation,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
assume $IsGoodHeap($tarHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);

label_END_rule_RA2A_applier:

}
