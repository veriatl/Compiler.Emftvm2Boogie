// ---------------------------------------------------------------
// -- Native library of ATL transformation framework -------------
// ---------------------------------------------------------------
  
const classifierTable : [String, String] ClassName;

var $srcHeap : HeapType where $IsGoodHeap($srcHeap);
var $tarHeap : HeapType where $IsGoodHeap($tarHeap);
var $linkHeap : HeapType where $IsGoodHeap($tarHeap);



function getTarsBySrcs(Seq ref): ref;

function getTarsBySrcs_inverse(ref): Seq ref;
axiom (forall i: Seq ref :: { getTarsBySrcs(i) } getTarsBySrcs_inverse(getTarsBySrcs(i)) == i);

function getTarsBySrcs2(Seq ref): ref;

function getTarsBySrcs2_inverse(ref): Seq ref;
axiom (forall i: Seq ref :: { getTarsBySrcs2(i) } getTarsBySrcs2_inverse(getTarsBySrcs2(i)) == i);



// TODO: refactoring, heap is not used as a parameter.
procedure EMFTVM#Resolve<alpha>(stk: Seq BoxType, heap: HeapType, e: alpha) returns (newStk: Seq BoxType);
  ensures newStk == Seq#Build(
	Seq#Take(stk, Seq#Length(stk)-1), 
	EMFTVM#Resolve#Sem($Unbox(Seq#Index(stk, Seq#Length(stk)-1)), $srcHeap, $tarHeap, e)
	);

function EMFTVM#Resolve#Sem<alpha>(this: ref, iHeap: HeapType, oHeap: HeapType, elem: alpha) : BoxType;
	axiom (forall this:ref, iHeap, oHeap: HeapType, elem: String ::
		EMFTVM#Resolve#Sem(this, iHeap, oHeap, elem) == $Box(elem)
	);
	axiom (forall this:ref, iHeap, oHeap: HeapType, elem: bool ::
		EMFTVM#Resolve#Sem(this, iHeap, oHeap, elem) == $Box(elem)
	);	
	axiom (forall this:ref, iHeap, oHeap: HeapType, elem: int ::
		EMFTVM#Resolve#Sem(this, iHeap, oHeap, elem) == $Box(elem)
	);
	axiom (forall this:ref, iHeap, oHeap: HeapType, elem: ref ::
		dtype(elem) != class._System.array ==>
		EMFTVM#Resolve#Sem(this, iHeap, oHeap, elem) == $Box(getTarsBySrcs(Seq#Singleton(elem)))
	);
	axiom (forall this:ref, iHeap, oHeap: HeapType, elem: ref ::
		dtype(elem) == class._System.array ==>
		  _System.array.Length($Unbox(EMFTVM#Resolve#Sem(this, iHeap, oHeap, elem))) == _System.array.Length(elem) 
		  && dtype($Unbox(EMFTVM#Resolve#Sem(this, iHeap, oHeap, elem))) == class._System.array
		  && ( forall __i: int :: 0<=__i && __i<_System.array.Length(elem) ==>
              $Unbox(read(oHeap, $Unbox(EMFTVM#Resolve#Sem(this, iHeap, oHeap, elem)), IndexField(__i))):ref == getTarsBySrcs(Seq#Singleton( $Unbox(read(iHeap, elem, IndexField(__i))): ref) )
		  ));
	
function invisble#getLinkbySources(s: Set ref): ref;
  axiom (forall s1,s2 : Set ref :: !Set#Equal(s1,s2) ==> 
	invisble#getLinkbySources(s1) != invisble#getLinkbySources(s2));
	
/* ------------------------------------------------------ */ 

function Fun#LIB#AllInstanceFrom(h:HeapType, t: ClassName): Seq ref;
  // the length of the return result is >=0; can be useful for termination proof.
  axiom (forall h:HeapType, t: ClassName :: 
    Seq#Length(Fun#LIB#AllInstanceFrom(h, t)) >= 0
  ); 
  // all the model elements contained by the return result are of type $t$.
  axiom (forall h:HeapType, t: ClassName, i:int :: 
	( 0<=i && i<Seq#Length(Fun#LIB#AllInstanceFrom(h,t)) ) ==> 
		dtype( Seq#Index(Fun#LIB#AllInstanceFrom(h,t),i) ) <: t
  );
  // all the model elements contained by the return result are allocated
  axiom (forall h:HeapType, t: ClassName, i:int :: 
	( 0<=i && i<Seq#Length(Fun#LIB#AllInstanceFrom(h,t)) ) ==> 
		h[Seq#Index(Fun#LIB#AllInstanceFrom(h,t),i), alloc] && Seq#Index(Fun#LIB#AllInstanceFrom(h,t),i) != null
  );
  // all the allocated ref that of type $t$ are contained by the return result. 
  axiom (forall h:HeapType, o: ref, t: ClassName :: 
	(h[o, alloc] && (dtype(o) <: t)) ==>
		Seq#Contains(Fun#LIB#AllInstanceFrom(h,t),o)
  );
  // all the model elements contained by the return result are unique 
  axiom (forall h:HeapType, t: ClassName, i,j:int :: 
    ( (0<=i && i<Seq#Length(Fun#LIB#AllInstanceFrom(h, t))) && 
	  (i+1<=j && j<Seq#Length(Fun#LIB#AllInstanceFrom(h, t))) ) ==>
		Seq#Index(Fun#LIB#AllInstanceFrom(h, t),i) != Seq#Index(Fun#LIB#AllInstanceFrom(h, t),j)
  ); 
  
 
procedure LIB#AllInstanceFrom(stk: Seq BoxType, h: HeapType) returns (newStk: Seq BoxType, res: Seq ref);
  ensures res == Fun#LIB#AllInstanceFrom(h, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)));
  ensures newStk == Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), $Box(res));
 
 
 
 
 
/* h refers to linkheap, r referes to the rule name */
function NTransientLinkSet#getLinksByRule(h:HeapType, rule: String): Seq ref;
  // the length of the return result is >=0; can be useful for termination proof.
  axiom (forall h:HeapType, r: String :: 
    Seq#Length(NTransientLinkSet#getLinksByRule(h, r)) >= 0
  ); 
  // unique links
  axiom (forall h:HeapType, r: String, i,j:int :: 
    ( (0<=i && i<Seq#Length(NTransientLinkSet#getLinksByRule(h,r))) && 
	  (i+1<=j && j<Seq#Length(NTransientLinkSet#getLinksByRule(h,r)) ) ==>
		Seq#Index(NTransientLinkSet#getLinksByRule(h, r),i) != Seq#Index(NTransientLinkSet#getLinksByRule(h, r),j)
  ));
  
		
//--------------------------------
//-------- Helper Function -------
//--------------------------------

function top(Seq BoxType): BoxType;
  axiom (forall stk: Seq BoxType :: top(stk) == Seq#Index(stk, Seq#Length(stk)-1));


  

procedure OCL#Object#Equal<T> (stk: Seq BoxType, o1: T, o2: T) returns (newStk: Seq BoxType);
  requires Seq#Length(stk) >= 2;
  ensures newStk == Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), $Box(
	o1 == o2
  ));  







	// see org.eclipse.m2m.atl.engine.emfvm.lib.TransientLink
const unique TransientLink#source: Field (Map String ref);
const unique TransientLink#target: Field (Map String ref);
const unique TransientLink#rule: Field String;


const unique #native$Collection: ClassName;
