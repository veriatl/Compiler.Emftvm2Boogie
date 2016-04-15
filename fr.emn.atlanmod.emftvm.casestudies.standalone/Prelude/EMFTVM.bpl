// -----------------------------------------------------
// -- Proof System for EMFTVM Instruction Set ----------
// -----------------------------------------------------
  
/*
 * TODO
 * - Consider refactoring the compilation knowledges.
 */  
  
// -----------------------------------------------------
// -- EMFTVM Stack Handlling                  ----------
// -----------------------------------------------------
  
function OpCode#Aux#InitStk(): Seq BoxType;
  axiom OpCode#Aux#InitStk() == (Seq#Empty(): Seq BoxType);
 
//Instr: PUSH  
procedure OpCode#PUSH(stk: Seq BoxType, s: String) returns (newStk: Seq BoxType);
  ensures newStk == Seq#Build(stk, $Box(s));

//Instr: PUSHI 
procedure OpCode#PUSHI(stk: Seq BoxType, i: int) returns (newStk: Seq BoxType);
  ensures newStk == Seq#Build(stk, $Box(i));  
  
//Instr: PUSHF  
procedure OpCode#PUSHF(stk: Seq BoxType) returns (newStk: Seq BoxType);
  ensures newStk == Seq#Build(stk, $Box(false));

//Instr: PUSHT
procedure OpCode#PUSHT(stk: Seq BoxType) returns (newStk: Seq BoxType);
  ensures newStk == Seq#Build(stk, $Box(true));
  
//Instr: POP 
procedure OpCode#POP(stk: Seq BoxType) returns (newStk: Seq BoxType);
  requires Seq#Length(stk) > 0;
  ensures newStk == Seq#Take(stk, Seq#Length(stk)-1);
  
//Instr: STORE
procedure OpCode#STORE<T>(stk: Seq BoxType) returns(newStk: Seq BoxType, topVal: T);
  requires Seq#Length(stk) > 0;
  ensures newStk == Seq#Take(stk, Seq#Length(stk)-1);
  ensures topVal == $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
  
//Instr: LOAD
procedure OpCode#LOAD<T>(stk: Seq BoxType, v: T) returns (newStk: Seq BoxType);
  ensures newStk == Seq#Build(stk, $Box(v));
 
//Instr: SWAP
procedure OpCode#SWAP(stk: Seq BoxType) returns (newStk: Seq BoxType);
  requires Seq#Length(stk) > 1;
  ensures newStk == Seq#Build(Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), Seq#Index(stk, Seq#Length(stk)-1)), Seq#Index(stk, Seq#Length(stk)-2));

//Instr: SWAP_X1
procedure OpCode#SWAPX1(stk: Seq BoxType) returns (newStk: Seq BoxType);
  requires Seq#Length(stk) > 2;
  ensures newStk == Seq#Build(Seq#Build(Seq#Build(Seq#Take(stk, Seq#Length(stk)-3), Seq#Index(stk, Seq#Length(stk)-2)), Seq#Index(stk, Seq#Length(stk)-1)), Seq#Index(stk, Seq#Length(stk)-3));
 
//Instr: DUP
procedure OpCode#DUP(stk: Seq BoxType) returns (newStk: Seq BoxType);
  requires Seq#Length(stk) > 0;
  ensures newStk == Seq#Build(stk, Seq#Index(stk, Seq#Length(stk)-1));

//Instr: DUP_X1
procedure OpCode#DUPX1(stk: Seq BoxType) returns (newStk: Seq BoxType);
  requires Seq#Length(stk) > 1;
  ensures newStk == Seq#Build(Seq#Build(Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), Seq#Index(stk, Seq#Length(stk)-1)), Seq#Index(stk, Seq#Length(stk)-2)), Seq#Index(stk, Seq#Length(stk)-1));

//Instr: NOT
procedure OpCode#NOT(stk: Seq BoxType) returns (newStk: Seq BoxType);
  requires Seq#Length(stk) > 0;
  ensures newStk == Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(!$Unbox(Seq#Index(stk, Seq#Length(stk)-1))));
   
//Instr: AND Stmt, [compile mechanism]
/*
	assert Seq#Length(stk) > 0;
	Compile(Stmt)
	stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), 
	                 $Box( $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) 
					       && $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) ));
*/

//Instr: OR Stmt, [compile mechanism]
/*
	assert Seq#Length(stk) > 0;
	Compile(Stmt)
	stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), 
	                 $Box( $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) 
					       || $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) ));
*/

//Instr: XOR
procedure OpCode#XOR(stk: Seq BoxType) returns (newStk: Seq BoxType);
requires Seq#Length(stk) > 1;
ensures newStk == Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), 
	                 $Box( ($Unbox(Seq#Index(stk, Seq#Length(stk)-2)) || $Unbox(Seq#Index(stk, Seq#Length(stk)-1)))
					       && !($Unbox(Seq#Index(stk, Seq#Length(stk)-2)) && $Unbox(Seq#Index(stk, Seq#Length(stk)-1))) ));  

//Instr: IMPLY Stmt, [compile mechanism]
/*
	assert Seq#Length(stk) > 0;
	Compile(Stmt)
	stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), 
	                 $Box( $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) 
					       ==> $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) ));
*/

//Instr: ISNULL
procedure OpCode#ISNULL(stk: Seq BoxType) returns (newStk: Seq BoxType);
  requires Seq#Length(stk) > 0;
  ensures newStk == Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), 
                              $Box( $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) == null ));
  

//Instr: GET_CB Stmt, [compile mechanism]
/*
	new_label:
		Compile(Stmt)
*/

//Instr: GET_TRANS, currently not supported


// -----------------------------------------------------
// -- EMFTVM Control Flow                     ----------
// -----------------------------------------------------
//Instr: GOTO n, [compile mechanism]
/*
	goto label_n:
	...
	label_n:		
*/

//Instr: RETURN, [compile mechanism]
/*
	goto CB_ID#END:
	...
	CB_ID#END:		
*/

//Instr: IF n, [compile mechanism]
/*
	var cond#: bool;
	assert Seq#Length(stk) > 0;
	cond#:= $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
	stk := Seq#Take(stk, Seq#Length(stk)-1);
	if (cond#) 
	  {goto label_n;}
	...
	label_n:		
*/

//Instr: IFN n, [compile mechanism]
/*
	var cond#: bool;
	assert Seq#Length(stk) > 0;
	cond#:= $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
	stk := Seq#Take(stk, Seq#Length(stk)-1);
	if (!cond#) 
	  {goto label_n;}
	...
	label_n:		
*/

//Instr: IFTE Stmt1 Stmt2, [compile mechanism]
/*
	var cond#: bool;
	assert Seq#Length(stk) > 0;
	cond#:= $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
	stk := Seq#Take(stk, Seq#Length(stk)-1);
	if (cond#) 
	  Compile(Stmt1)
	else
	  Compile(Stmt2)		
*/

//Instr: ITERATE Stmt ENDITERATE, [compile mechanism]
/*
	var col#: Seq ref;
	var counter#: int;
	assert Seq#Length(stk) > 0;
	col#:= $Unbox(Seq#Index(stk, Seq#Length(stk)-1));
	stk := Seq#Take(stk, Seq#Length(stk)-1);
	counter# := 0;
	while (counter# < Seq#Length(col#))
	{
		stk := Seq#Build(stk, $Box(Seq#Index(col#, counter#)));
		Compile(Stmt)
		counter# := counter#+1;
	}		
*/

//Instr: INVOKE sig n, [compile mechanism]
/*
	var result# : T;
	assert Seq#Length(stk) >= n;
	call result# := Compile_signature(sig);
	stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-n), $Box(result#));
*/


//Instr: INVOKE_STATIC sig n, [compile mechanism]
/*
	var result# : T;
	assert Seq#Length(stk) >= n;
	call result# := Compile_signature(sig);
	stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-n), $Box(result#));
*/

//Instr: INVOKE_CB Stmt n, [compile mechanism]
/*
	var stk# : Seq BoxType;
	assert Seq#Length(stk) >= n;
	stk# := stk;
	stk := Seq#Drop(stk, Seq#Length(stk)-n);
	Compile(Stmt)
	...
	CB_ID#END:
		stk := Seq#Build(Seq#Take(stk#, Seq#Length(stk#)-n), Seq#Index(stk, Seq#Length(stk)-1));
*/

//Instr: INVOKE_CB_S n, [compile mechanism]
/*
	var stk# : Seq BoxType;
	assert Seq#Length(stk) >= n;
	stk# := stk;
	stk := Seq#Drop(stk, Seq#Length(stk)-n);
	goto LABEL#CB_S;
	...
	CB_ID#END:
		stk := Seq#Build(Seq#Take(stk#, Seq#Length(stk#)-n), Seq#Index(stk, Seq#Length(stk)-1));
*/

//Instr: INVOKE_SUPER, currently not supported

//Instr: INVOKE_ALL_CBS, currently not supported

// -----------------------------------------------------
// -- EMFTVM Model Handlling                  ----------
// -----------------------------------------------------
  
//Instr: NEW mm, [compile mechanism]
/*
	var _placehold : ref;
	assert Seq#Length(stk) > 0;
	havoc _placehold;
    assume _placehold != null && !read($xHeap, _placehold, alloc) && dtype(_placehold) == 
	classifierTable[ Compile(mm), 
					($Unbox(Seq#Index(stk, Seq#Length(stk)-1)): String)];
	$xHeap := update($xHeap, _placehold, alloc, true);
	assume $IsGoodHeap($xHeap);
	stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(_placehold));
*/

//Instr: NEW_S, [compile mechanism]
/*
	assert Seq#Length(stk) > 1;
	havoc _placehold;
    assume _placehold != null && !read($xHeap, _placehold, alloc) && dtype(_placehold) == 
	classifierTable[($Unbox(Seq#Index(stk, Seq#Length(stk)-1)): String), 
					($Unbox(Seq#Index(stk, Seq#Length(stk)-2)): String)];
	$xHeap := update($xHeap, _placehold, alloc, true);
	assume $IsGoodHeap($xHeap);
	stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), $Box(_placehold));
*/


// Instr: GET f, [compile mechanism]
/*
	assert Seq#Length(stk) > 0;
	assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null && read($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), alloc);
	stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)), Compile(f))));
*/


// Instr: SET f, [compile mechanism]
/*
	assert Seq#Length(stk) > 1;
	assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null && read($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);
	stk := update($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), Compile(f), $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
	stk := Seq#Take(stk, Seq#Length(stk)-2);
*/

// Instr: GET_STATIC f, [compile mechanism]
/*
	assert Seq#Length(stk) > 0;
	stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(read($xHeap, toRef($Unbox(Seq#Index(stk, Seq#Length(stk)-1))), Compile(f))));
*/


// Instr: SET_STATIC f, [compile mechanism]
/*
	assert Seq#Length(stk) > 1;
	stk := update($xHeap, toRef($Unbox(Seq#Index(stk, Seq#Length(stk)-2))), Compile(f), $Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
	stk := Seq#Take(stk, Seq#Length(stk)-2);
*/

  
// Instr: FINDTYPE mm cl
procedure OpCode#FINDTYPE(stk: Seq BoxType, mm: String, cl: String) returns(newStk: Seq BoxType);
  ensures newStk == Seq#Build(stk, $Box(classifierTable[mm, cl]));
												   
// Instr: FINDTYPE_S
procedure OpCode#FINDTYPE_S(stk: Seq BoxType) returns(newStk: Seq BoxType);
  requires Seq#Length(stk) > 1;
  ensures newStk == Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), 
							  $Box(classifierTable[($Unbox(Seq#Index(stk, Seq#Length(stk)-1)): String), 
												   ($Unbox(Seq#Index(stk, Seq#Length(stk)-2)): String)]));

// Instr: ALLINST
procedure OpCode#ALLINST(stk: Seq BoxType, h: HeapType) returns(newStk: Seq BoxType);
  requires Seq#Length(stk) > 0;
  ensures newStk == Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), 
							  $Box(Fun#LIB#AllInstanceFrom(h, ($Unbox(Seq#Index(stk, Seq#Length(stk)-1)): ClassName))));

// Instr: ALLINST_IN
procedure OpCode#ALLINST_IN(stk: Seq BoxType) returns(newStk: Seq BoxType);
  requires Seq#Length(stk) > 1;
  ensures newStk == Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), 
							  $Box(Fun#LIB#AllInstanceFrom(($Unbox(Seq#Index(stk, Seq#Length(stk)-1)): HeapType), ($Unbox(Seq#Index(stk, Seq#Length(stk)-2)): ClassName))));


//Instr: DELETE, [compile mechanism]
/*

var heap# : HeapType;
assert Seq#Length(stk) > 0;
heap# := heap;
assert Seq#Index(stk, Seq#Length(stk)-1) != null && read(heap, Seq#Index(stk, Seq#Length(stk)-1), alloc);
havoc heap;
assume (forall<alpha> r: ref, f: Field alpha ::
	r != null and read(heap#, r, alloc) && r!=Seq#Index(stk, Seq#Length(stk)-1) ==>
		read(heap, r, f) = read(heap# , r, f));
assume !read(heap, Seq#Index(stk, Seq#Length(stk)-1), alloc);
stk := Seq#Take(stk, Seq#Length(stk)-1);

*/
							  
//Instr: ADD f, [compile mechanism]
/*
assert Seq#Length(stk) >= 2;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
if(isCollection(Compile(f))){
	havoc $newCol;
	assume dtype($newCol) == class._System.array;
	assume $newCol != null && read($xHeap, $newCol, alloc);
	assume Seq#FromArray($xHeap,$newCol) == Seq#Append(Seq#FromArray($xHeap, read($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), Compile(f))), Seq#FromArray($xHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1))));
	$xHeap := update($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), 
					Compile(f), 
					$newCol
					);
}else{
	assert !isSet(acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), Compile(f));
	$xHeap := update($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), 
					Compile(f), 
					$Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
	acc := set(acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), Compile(f), true);
}
assume $IsGoodHeap($xHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);
*/


//Instr: REMOVE f, [compile mechanism]
/*
assert Seq#Length(stk) >= 2;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;
if(isCollection(Compile(f))){
	havoc $newCol;
	assume dtype($newCol) == class._System.array;
	assume $newCol != null && read($xHeap, $newCol, alloc);
	assume (forall o: BoxType :: Seq#Contains(Seq#FromArray($xHeap,$newCol), o) <==> 
		Seq#Contains(Seq#FromArray($xHeap, read($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), Compile(f))), o)
		&& !Seq#Contains(Seq#FromArray($xHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-1))), o));

	$xHeap := update($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), 
					Compile(f), 
					$newCol
					);	
}else{
	if(read($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), Compile(f)) == $Unbox(Seq#Index(stk, Seq#Length(stk)-1)))
	{
		assert isSet(acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), Compile(f));
		$xHeap := update($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), 
						Compile(f), 
						$Unbox(Seq#Index(stk, Seq#Length(stk)-1)));
		acc := set(acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), Compile(f), false);	
	}
}
assume $IsGoodHeap($xHeap);
stk := Seq#Take(stk, Seq#Length(stk)-2);
*/

//Instr: INSERT f, [compile mechanism]
/*
assert Seq#Length(stk) > 2;
assert $Unbox(Seq#Index(stk, Seq#Length(stk)-3)) != null;
assert read($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-3)), alloc);

if(isCollection()){
	havoc $newCol;
	assume dtype($newCol) == class._System.array;
	assume $newCol != null && read($xHeap, $newCol, alloc);
	assert -1 <= $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) && $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) < Seq#Length(Seq#FromArray($tarHeap, read($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-3)), Compile(f))));
	assume Seq#FromArray($xHeap,$newCol) == 
		Seq#Append(	
			Seq#Append(Seq#Take(Seq#FromArray($xHeap, 
							read($xHeap, 
								$Unbox(Seq#Index(stk, Seq#Length(stk)-3)), 
								Compile(f)))	
						, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)))
				, Seq#FromArray($xHeap,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)))
			)
			, Seq#Drop(Seq#FromArray($xHeap, 
							read($xHeap, 
								$Unbox(Seq#Index(stk, Seq#Length(stk)-3)), 
								Compile(f)))	
						, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)))
		);			
	$xHeap := update($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-3)), 
					Compile(f), 
					$newCol
					);
}else{
	assert !isSet(acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-3)), Compile(f));
	$xHeap := update($xHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-3)), 
					Compile(f), 
					$Unbox(Seq#Index(stk, Seq#Length(stk)-2)));
	acc := set(acc, $Unbox(Seq#Index(stk, Seq#Length(stk)-3)), Compile(f), true);
}

assume $IsGoodHeap($xHeap);
stk := Seq#Take(stk, Seq#Length(stk)-3);	
*/

// Instr: GETENV  
procedure OpCode#GETENV(stk: Seq BoxType) returns(newStk: Seq BoxType);
  ensures newStk == Seq#Build(stk, $Box(Exec));
  
// Instr: GETENVTYPE  
procedure OpCode#GETENVTYPE(stk: Seq BoxType) returns(newStk: Seq BoxType);
  ensures newStk == Seq#Build(stk, $Box(dtype(Exec)));
  
  
//Instr: MATCH, currently not supported

//Instr: MATCH_S, currently not supported

//Instr: GET_SUPER, currently not supported

const unique System.reserved: ClassName;  
const unique Exec: ref;
  axiom Exec != null;
  axiom dtype(Exec) <: System.reserved;
  axiom (forall h:HeapType::read(h,Exec,alloc));