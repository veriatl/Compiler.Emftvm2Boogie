/*
 * Verifying Resolving algorithm
 */	
procedure __resolve__(this: ref, obj: ref) returns (r: ref)
modifies $tempHeap;
ensures dtype(obj) != class._System.array && NTransientLink#getDefaultSourceElement#Spec(read($linkHeap,Asm,ASM.links), obj) == null
==> r == obj;
ensures dtype(obj) != class._System.array && !(NTransientLink#getDefaultSourceElement#Spec(read($linkHeap,Asm,ASM.links), obj) == null || !read($linkHeap, NTransientLink#getDefaultSourceElement#Spec(read($linkHeap,Asm,ASM.links), obj), alloc))
==> r == getTarsBySrcs(Seq#Singleton(obj));
ensures dtype(obj) == class._System.array ==> dtype(r) == class._System.array ;
ensures dtype(obj) == class._System.array ==> Seq#Length(Seq#FromArray($srcHeap, obj)) == Seq#Length(Seq#FromArray($tempHeap, r));
ensures dtype(obj) == class._System.array ==> 
	(forall __i: int :: 0<=__i && __i<Seq#Length(Seq#FromArray($srcHeap, obj)) ==>
		isResolved($Unbox(Seq#Index(Seq#FromArray($srcHeap, obj),__i))));
ensures dtype(obj) != class._System.array && !(NTransientLink#getDefaultSourceElement#Spec(read($linkHeap,Asm,ASM.links), obj) == null || !read($linkHeap, NTransientLink#getDefaultSourceElement#Spec(read($linkHeap,Asm,ASM.links), obj), alloc))
==> (old($tempHeap) == $tempHeap);
{

var stk: Seq BoxType;
var e: BoxType;	//slot: lv2
var value: ref;	//slot: lv1
var self: ref;	//slot: lv0
var obj#21: Seq BoxType;
var obj#25: ref;
var $counter#22: int;

var obj#19: ref;
var cond#3: bool;
var cond#10: bool;

var _heap: HeapType;
var _col: ref;


self := this;
value := obj;

stk := OpCode#Aux#InitStk();

// 0:	LOAD lv1 
call stk := OpCode#LOAD(stk, value);
// 1:	FINDTYPE #native Collection
call stk := OpCode#FINDTYPE(stk, _#native, _Collection);
// 2:	INVOKE oclIsKindOf()
call stk := OCLAny#IsTypeof(stk);
// 3:	IF 17 
cond#3 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(cond#3){goto label_17;}
// 4:	GETENV 
call stk := OpCode#GETENV(stk);
// 5:	INVOKE getTraces()
call stk := Env#getTraces(
	stk,
	$Unbox(Seq#Index(stk, Seq#Length(stk)-2)),
	$Unbox(Seq#Index(stk, Seq#Length(stk)-1))
);
// 6:	LOAD lv1 
call stk := OpCode#LOAD(stk, value);
// 7:	INVOKE getDefaultSourceElement()
call stk := NTransientLink#getDefaultSourceElement(
	stk,
	$Unbox(Seq#Index(stk, Seq#Length(stk)-2)),
	$Unbox(Seq#Index(stk, Seq#Length(stk)-1))
);
// 8:	DUP 
call stk := OpCode#DUP(stk);
// 9:	ISNULL
call stk := OpCode#ISNULL(stk);
// 10:	IF 14 
cond#10 := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
call stk := OpCode#POP(stk);
if(cond#10){goto label_14;}
// 11:	LOAD lv1 
call stk := OpCode#LOAD(stk, value);
// 12:	INVOKE getTargetFromSource() 
call stk := NTransientLink#getTargetFromSource(
	stk,
	$Unbox(Seq#Index(stk, Seq#Length(stk)-1))
);
// 13:	GOTO 16 
goto label_16;
label_14:
// 14:	POP 
call stk := OpCode#POP(stk);
// 15:	LOAD lv1 
call stk := OpCode#LOAD(stk, value);
label_16:
// 16:	GOTO 30 
goto label_30;
label_17:
// 17:	PUSH Sequence 
call stk := OpCode#PUSH(stk, _Sequence);
// 18:	PUSH #native 
call stk := OpCode#PUSH(stk, _#native);
// 19:	NEW 
assert Seq#Length(stk) >= 2;
havoc obj#19;
assume obj#19!= null && !read($tempHeap, obj#19, alloc) && dtype(obj#19) == class._System.array;
$tempHeap := update($tempHeap, obj#19, alloc, true);
assume $IsGoodHeap($tempHeap);
assume $HeapSucc(old($tempHeap), $tempHeap);
assume Seq#Length(Seq#FromArray($tempHeap, obj#19)) == 0;

stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), $Box(obj#19));
// 20:	LOAD lv1 
call stk := OpCode#LOAD(stk, value);
// 21:	ITERATE 
obj#21 := Seq#FromArray($srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));

$counter#22:=0;
call stk := OpCode#POP(stk);

while($counter#22<Seq#Length(obj#21)) 
invariant $counter#22<=Seq#Length(obj#21);
invariant dtype($Unbox(Seq#Index(stk, Seq#Length(stk)-1))) == class._System.array;
invariant Seq#Length(Seq#FromArray($tempHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)))) == $counter#22;
invariant (forall __i: int :: 0<=__i && __i<$counter#22 ==>
		isResolved($Unbox(Seq#Index(obj#21, __i))));
invariant (forall __i: int :: 0<=__i && __i<$counter#22 ==>
	$Unbox(Seq#Index(Seq#FromArray($tempHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1))), __i))
		== getTarsBySrcs(Seq#Singleton($Unbox(Seq#Index(obj#21, __i)))));
{
	stk := Seq#Build(stk, $Box(Seq#Index(obj#21, $counter#22)));
	
	// we assume every element in the array is not an array to ensure termination (Common for the input models of ATL). 
	// EMF allows the element in the array to be still an array, in this case,
	// the follow property is useful:
	// assume _System.array.Length($Unbox(Seq#Index(obj#21, $counter#22))) < _System.array.Length(obj#21);
	// which is generally true for tree-like data strctures.
	assume !(NTransientLink#getDefaultSourceElement#Spec(read($linkHeap,Asm,ASM.links), $Unbox(Seq#Index(obj#21, $counter#22))) == null || !read($linkHeap, NTransientLink#getDefaultSourceElement#Spec(read($linkHeap,Asm,ASM.links), $Unbox(Seq#Index(obj#21, $counter#22))), alloc));
	assume dtype($Unbox(Seq#Index(obj#21, $counter#22))) != class._System.array;
	
	// 22:	STORE lv2 
	call stk, e := OpCode#STORE(stk);	
	// 23:	GETENV 
	call stk := OpCode#GETENV(stk);
	// 24:	LOAD lv2 
	call stk := OpCode#LOAD(stk, e);	
	// 25:	INVOKE __resolve__
	_heap := $tempHeap;		
	call obj#25 := __resolve__(this, $Unbox(e));
	stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), $Box(obj#25));
	assume isResolved($Unbox(e));		
	// 26:	INVOKE including()
	call stk := Collection#Including(stk);
	// 27:	ENDITERATE 
	$counter#22 := $counter#22+1;
	

}
// 28:	
label_30:
	r := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
}







/*
 * Semantics of Sub Calls
 */
function isResolved(x: ref): bool;  

procedure Env#getTraces
	(stk:Seq BoxType, links: Set ref, src: ref)
returns
	(newStk:Seq BoxType);
requires Seq#Length(stk) >= 1;
requires $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;
requires read($linkHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);
ensures newStk == Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($linkHeap, Asm, ASM.links)));
	
function NTransientLink#getDefaultSourceElement#Spec(links: Set ref, src: ref): ref;
	
procedure NTransientLink#getDefaultSourceElement
	(stk:Seq BoxType, links: Set ref, src: ref)
returns
	(newStk:Seq BoxType);
requires Seq#Length(stk) >= 2; 
ensures Seq#Length(stk) == Seq#Length(newStk)+1;
ensures Seq#Equal(
	Seq#Take(stk, Seq#Length(stk)-2),
	Seq#Take(newStk, Seq#Length(newStk)-1)
);
ensures $Unbox(Seq#Index(newStk, Seq#Length(newStk)-1)) == NTransientLink#getDefaultSourceElement#Spec(links, src);


  
procedure NTransientLink#getTargetFromSource
	(stk:Seq BoxType, src: ref)
returns
	(newStk:Seq BoxType);
requires Seq#Length(stk) >= 1; 
ensures Seq#Length(stk) == Seq#Length(newStk);
ensures Seq#Equal(
	Seq#Take(stk, Seq#Length(stk)-1),
	Seq#Take(newStk, Seq#Length(newStk)-1)
);
ensures $Unbox(Seq#Index(newStk, Seq#Length(newStk)-1)) == getTarsBySrcs(Seq#Singleton(src));
	
procedure Collection#Including
  (stk: Seq BoxType) 
returns
  (newStk: Seq BoxType);
requires dtype($Unbox(Seq#Index(stk, Seq#Length(stk)-2))) == class._System.array;
modifies $tempHeap;
ensures newStk == Seq#Take(stk, Seq#Length(stk)-2);
ensures dtype($Unbox(Seq#Index(newStk, Seq#Length(newStk)-1))) == dtype($Unbox(Seq#Index(stk, Seq#Length(stk)-2)));
ensures Seq#FromArray($tempHeap, $Unbox(Seq#Index(newStk, Seq#Length(newStk)-1))) == 
			Seq#Build(
				Seq#FromArray(old($tempHeap), $Unbox(Seq#Index(stk, Seq#Length(stk)-2))),
				Seq#Index(stk, Seq#Length(stk)-1));
ensures (forall<alpha> $o: ref, $f: Field alpha ::  
	$o != $Unbox(Seq#Index(newStk, Seq#Length(newStk)-1)) ==> 
		read($tempHeap, $o, $f) == read(old($tempHeap), $o, $f));
		
/*
 * Aux data structures
 */
 
var $tempHeap : HeapType;	// temp heap, to store tempory objects, disjoint from source/target/link heaps.

const unique _TransientLink : String;
const unique _#native : String;
const unique _Sequence : String;
const unique _Collection : String;

  axiom classifierTable[_#native, _TransientLink] == Native$TransientLink;
  axiom classifierTable[_#native, _Collection] == class._System.array;
  
const unique class._System.Integer: ClassName;
const unique class._System.Boolean: ClassName;
const unique class._System.String: ClassName;

// ASM-specific
const System.reserved: ClassName;
const unique Asm: ref;
  axiom Asm != null;
  axiom dtype(Asm) <: System.reserved;
  axiom (forall h:HeapType::read(h,Asm,alloc));
const unique ASM.links : Field (Set ref);
const unique Native$TransientLink: ClassName;

  
function toRef<T>(x: T): ref;
  axiom (forall i: int :: dtype(toRef(i)) == class._System.Integer);
  axiom (forall b: bool :: dtype(toRef(b)) == class._System.Boolean);
  axiom (forall s: String :: dtype(toRef(s)) == class._System.String);

function unRef<T>(x: ref): T;
  axiom (forall i: int :: unRef(toRef(i)) == i);
  axiom (forall i: bool :: unRef(toRef(i)) == i);
  axiom (forall i: String :: unRef(toRef(i)) == i);		
	