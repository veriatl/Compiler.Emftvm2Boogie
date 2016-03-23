package fr.emn.atlanmod.emftvm2boogie.core;

import java.io.File;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;

import org.eclipse.emf.ecore.EPackage;
import org.eclipse.m2m.atl.core.emf.EMFModel;
import org.eclipse.m2m.atl.emftvm.CodeBlock;
import org.eclipse.m2m.atl.emftvm.ExecEnv;
import org.eclipse.m2m.atl.emftvm.InputRuleElement;
import org.eclipse.m2m.atl.emftvm.Instruction;
import org.eclipse.m2m.atl.emftvm.LocalVariable;
import org.eclipse.m2m.atl.emftvm.Opcode;
import org.eclipse.m2m.atl.emftvm.OutputRuleElement;
import org.eclipse.m2m.atl.emftvm.Rule;
import org.eclipse.m2m.atl.emftvm.RuleMode;
import org.eclipse.m2m.atl.emftvm.impl.*;


import org.eclipse.m2m.atl.engine.vm.ASMInstruction;
import org.eclipse.m2m.atl.engine.vm.ASMInstructionWithOperand;
import org.eclipse.m2m.atl.engine.vm.ASMOperation;
import org.eclipse.m2m.atl.engine.vm.ASMOperation.LocalVariableEntry;

import fr.emn.atlanmod.emftvm2boogie.helper.EMFTVMReaderHelper;
import fr.emn.atlanmod.emftvm2boogie.helper.ATLModelInjector;
import fr.emn.atlanmod.emftvm2boogie.helper.CodeBlockHelper;
import fr.emn.atlanmod.emftvm2boogie.helper.EcoreReaderHelper;
import fr.emn.atlanmod.emftvm2boogie.helper.TypeStack;


public class Driver {

	static ExecEnv env;
	static EMFModel atl;
	
	static EPackage srcMM;
	static EPackage tarMM;
	static Map<String, String> ins = new HashMap<String, String>();
	static List<String> inIds = new ArrayList<String>();
	static Map<String, String> outs = new HashMap<String, String>();
	static Set<String> outTypes = new HashSet<String>();
	static Map<String, String> localVars = new HashMap<String, String>();
	static String rule;
	static String option;
	static Stack<String> iteratorStack = new Stack<String>();
	static Map<Integer, String> iteratorMap = new HashMap<Integer, String>();
	static Map<Integer, String> enditeratorMap = new HashMap<Integer, String>();
	static Map<String, String> attrInfo = new HashMap<String, String>(); 
	static Map<String, String> parentInfo = new HashMap<String, String>(); 
	static Map<String, String> srcsfInfo = new HashMap<String, String>(); 
	static Map<String, String> tarsfInfo = new HashMap<String, String>();
	static TypeStack typeStack; 
	static Map<Integer, List<String>> invPool = new HashMap<Integer, List<String>>();
	static int loopLevel = 0;

	static String srcHeap = "$srcHeap";
	static String tarHeap = "$tarHeap";
	

	static Set<Integer> bootstrap_getLabels(CodeBlock cb) {
		int ln = 0;
		HashSet<Integer> set = new HashSet<Integer>();

		for (Instruction instr : cb.getCode()) {
			if(instr instanceof BranchInstructionImpl){
				BranchInstructionImpl tempInstr = ((BranchInstructionImpl) instr);
				switch (instr.getOpcode()) {
				case GOTO:
				{
					
					set.add(tempInstr.getOffset());
					break;
				}
				case IF:
				{	
					set.add(tempInstr.getOffset());
					set.add(ln + 1);
					break;
				}
				case IFN:
				{	
					set.add(tempInstr.getOffset());
					set.add(ln + 1);
					break;
				}
				default:
					break;
				}
			}
			ln++;
		}


		
		return set;
	}
	
	static void bootstrap_addNewVars(CodeBlock cb) throws Exception {
		int ln = 0;
		for (Instruction instr: cb.getCode()) {
			
			switch (instr.getOpcode()) {
				case NEW:{
					System.out.printf("var obj#%d: ref;\n", ln);
					break;
				}
				case NEW_S:{
					System.out.printf("var obj#%d: ref;\n", ln);
					break;
				}
				case DELETE:{
					System.out.printf("var heap#%d: HeapType;\n", ln);
					break;
				}
				case ITERATE:{
					String col = String.format("obj#%d", ln - 1);
					String counter = String.format("$counter#%d", ln);
					System.out.printf("var %s: Seq ref;\n", col);
					System.out.printf("var %s: int;\n", counter);
					System.out.printf("var decreases#%s: int;\n", Integer.valueOf(ln) );
					iteratorStack.push(counter);
					iteratorMap.put(ln, counter);
					//invPool.put(loopLevel, genInvariant(counter, col));
					loopLevel++;
					break;
				}
				case ENDITERATE:
					enditeratorMap.put(ln, iteratorStack.pop());
					loopLevel--;
					break;
				case IF:
					System.out.printf("var cond#%d: bool;\n", ln);
					break;
				case IFN:
					System.out.printf("var cond#%d: bool;\n", ln);
					break;
				case IFTE:
					System.out.printf("var cond#%d: bool;\n", ln);
					break;
				case INVOKE:{
					System.out.printf("var obj#%d: bool;\n", ln);
					break;
				}
				case INVOKE_STATIC:{
					System.out.printf("var obj#%d: bool;\n", ln);
					break;
				}
				case INVOKE_CB:{
					System.out.printf("var stk#%d: Seq BoxType;\n", ln);
					break;
				}
				case INVOKE_CB_S:{
					System.out.printf("var stk#%d: Seq BoxType;\n", ln);
					break;
				}
				default:
					break;
			}
			
			


			ln++;
		}

	}


	

	
	

	
	
	/*
	 * instr: the instruction localVars: local variables table ln : lint number
	 */
	static String printInstr(Instruction instr, Map<String, String> localVars, int ln, CodeBlock cb, List<Instruction> instrs)
			throws Exception {
		String result = "";
		result = String.format("//%s: %s \n", ln, instr.getOpcode());
		
		
		if (instr instanceof FieldInstructionImpl) {
			FieldInstructionImpl tInstr = (FieldInstructionImpl) instr;
			
			String operand = tInstr.getFieldname();
			
			switch (tInstr.getOpcode()) {
			case ADD:
			{
				result += printAddInstr(operand);
				break;
			}
			case GET:
			{
				result += printGetInstr(operand, false);
				break;
			}
			case GET_STATIC:
			{
				result += printGetInstr(operand, true);
				break;
			}
			case INSERT:
			{
				result += printInsertInstr(operand);
				break;
			}
			case REMOVE:
			{
				result += printRemoveInstr(operand);
				break;
			}
			case SET:
				result += printSetInstr(operand, false);
				break;
			case SET_STATIC:
			{
				result += printSetInstr(operand, true);
				break;
			}
			default:
				result += String.format(instr.getOpcode() + " NOT SUPPORT");
				break;
			}
		}else if(instr instanceof LocalVariableInstructionImpl){
			LocalVariableInstructionImpl tInstr = ((LocalVariableInstructionImpl) instr);
			
			switch (instr.getOpcode()) {
			case STORE:
			{			
				String var_store = tInstr.getLocalVariable().getName();
				result += String.format("call stk, %s := OpCode#STORE(stk);", var_store);
				break;
			}
			case LOAD:
			{	
				String var_load =tInstr.getLocalVariable().getName();
				result += String.format("call stk := OpCode#LOAD(stk, %s);", var_load);
				break;
			}
			default:
			{	
				result += String.format(instr.getOpcode() + " NOT SUPPORT");
				break;
			}
			}
		}else if(instr instanceof BranchInstructionImpl){
			BranchInstructionImpl tInstr = ((BranchInstructionImpl) instr);
			
			switch (instr.getOpcode()) {
			case ENDITERATE:
			{
				String counter1 = enditeratorMap.get(ln);
				int conterLN = Integer.parseInt(counter1.substring(counter1.indexOf("#") + 1));
				result += String.format("%s := %s+1;\n", counter1, counter1);
				result += String.format("assert 0<= decreases#%d || Seq#Length(obj#%d) - %s == decreases#%d;\n", Integer.valueOf(conterLN), Integer.valueOf(conterLN - 1), counter1, Integer.valueOf(conterLN));
		        result += String.format("assert Seq#Length(obj#%d) - %s < decreases#%d;\n", Integer.valueOf(conterLN - 1), counter1, Integer.valueOf(conterLN) );
				result += String.format("}");
				loopLevel--;
				break;
			}
			case GOTO:
			{
				int operand = tInstr.getOffset();
				result = String.format("goto %s;", "label_" + Integer.toString(operand));
				break;
			}
			case IF:
			{	
				int operand = tInstr.getOffset();
				result = String.format("%s := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));\n", "cond#" + ln);
				result += String.format("call stk := OpCode#POP(stk);\n");
				result += String.format("if(cond#%d){goto %s;}", ln, "label_" + Integer.toString(operand));
				break;
			}
			case IFN: 
			{
				int operand = tInstr.getOffset();
				result = String.format("%s := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));\n", "cond#" + ln);
				result += String.format("call stk := OpCode#POP(stk);\n");
				result += String.format("if(!cond#%d){goto %s;}", ln, "label_" + Integer.toString(operand));
				break;
			}
			case ITERATE:
			{	
				String counter = iteratorMap.get(ln);
				result += String.format("obj#%d := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));\n", ln - 1);
				result += String.format("%s:=0;\n", counter);
				result += String.format("call stk := OpCode#POP(stk);\n");
				result += String.format("while(%s<Seq#Length(obj#%d)) \n", counter, ln - 1);
				for (String inv : invPool.get(loopLevel)) {
					result += inv;
				}
				result = result + String.format("{ decreases#%d := Seq#Length(obj#%d) - %s;\n", Integer.valueOf(ln), Integer.valueOf(ln - 1), counter );
				result += String.format("stk := Seq#Build(stk, $Box(Seq#Index(obj#%d, %s)));", ln - 1, counter);
				loopLevel++;
				break;
			}
			default:
				result = String.format(instr.getOpcode() + " NOT SUPPORT");
				break;
			}
		}else if(instr instanceof CodeBlockInstructionImpl){
			CodeBlockInstructionImpl tInstr = ((CodeBlockInstructionImpl) instr);
			CodeBlock tcb =  tInstr.getCodeBlock(); 
			switch (instr.getOpcode()) {
			case AND:
			{
				result += String.format("assert Seq#Length(stk) > 0;\n");
				printInstrs(tcb, localVars);
				result += String.format("stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), $Box( $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) && $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) ));\n");
				break;
			}
			case GETCB:{
				
				result += String.format("label_START_%s:\n",  tcb.toString().replace(" ", "_"));
				printInstrs(tcb, localVars);
				break;
			}
			case IMPLIES:
			{
				result += String.format("assert Seq#Length(stk) > 0;\n");
				printInstrs(tcb, localVars);
				result += String.format("stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), $Box( $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) ==> $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) ));\n");
				
				break;
			}
			case INVOKE_CB:
			{
				
				InvokeCbImpl invoke_cb = ((InvokeCbImpl) tInstr);
				result += String.format("assert Seq#Length(stk) >= n;\n");
				result += String.format("stk#%d := stk;\n", ln);
				result += String.format("stk := Seq#Drop(stk, Seq#Length(stk)-n);\n");
				printInstrs(invoke_cb.getCodeBlock(), localVars);
				result += String.format("label_END_%s:\n", invoke_cb.getCodeBlock().toString());
				result += String.format("stk := Seq#Build(Seq#Take(stk#%d, Seq#Length(stk#%d)-n), Seq#Index(stk, Seq#Length(stk)-1));\n", ln, ln);
				break;
			}
			case OR:
			{
				result += String.format("assert Seq#Length(stk) > 0;\n");
				printInstrs(tcb, localVars);
				result += String.format("stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), $Box( $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) || $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) ));\n");
				
				break;
			}
			default:
				result = String.format(instr.getOpcode() + " NOT SUPPORT");
				break;
			}
		}else if(instr instanceof InvokeInstructionImpl){
			
			
			switch (instr.getOpcode()) {
			case INVOKE_CB_S:
			{
				result += String.format("assert Seq#Length(stk) >= n;\n");
				result += String.format("stk#%d := stk;\n", ln);
				result += String.format("stk := Seq#Drop(stk, Seq#Length(stk)-n);\n");
				result += String.format("goto label_START_%s;\n", typeStack.top().getVal());
				result += String.format("label_END_%s:\n", typeStack.top().getVal());
				result += String.format("stk := Seq#Build(Seq#Take(stk#%d, Seq#Length(stk#%d)-n), Seq#Index(stk, Seq#Length(stk)-1));\n", ln, ln);
				break;
			}
			case INVOKE:
			{
				InvokeImpl tInstr = ((InvokeImpl) instr);
				String operand = tInstr.getOpname();
				result += EMFTVMReaderHelper.genCall(operand, ln, typeStack, false);
				break;
			}
			case INVOKE_STATIC:
			{
				InvokeImpl tInstr = ((InvokeImpl) instr);
				String operand = tInstr.getOpname();
				result += EMFTVMReaderHelper.genCall(operand, ln, typeStack, true);
				break;
			}
			default:
				result = String.format(instr.getOpcode() + " NOT SUPPORT");
				break;
			}
		}else{
			switch (instr.getOpcode()) {
			case ALLINST:
			{
				String hp = typeStack.get(typeStack.size()-1).getVal();
				result = String.format("call stk := OpCode#ALLINST(stk, %s);", hp);
				break;
			}
			case ALLINST_IN:
			{
				result = String.format("call stk := OpCode#ALLINST_IN(stk);");
				break;
			}
			case DELETE :
			{
				String o = "Seq#Index(stk, Seq#Length(stk)-1)";
				String tHeap = String.format("heap#%d", ln);
				result += String.format("assert Seq#Length(stk) >= n;\n");
				result += String.format("heap#%d := %s;\n", tarHeap, ln);
				result += String.format("assert %s!=null && read(%s, %s, alloc);\n", o, tarHeap, o);
				result += String.format("havoc %s;", tarHeap);
				
				result += String.format("assume (forall<alpha> r: ref, f: Field alpha :: r != null and read(%s, r, alloc) && r!=%s ==> read(%s, r, f) = read(%s , r, f));\n", tHeap, o, tarHeap, tHeap);
				result += String.format("assume !read(heap, %s, alloc);\n", o);
				
				result += String.format("stk := Seq#Take(stk, Seq#Length(stk)-1);\n");
				break;
			}
			case DUP:
			{	
				result = String.format("call stk := OpCode#DUP(stk);");
				break;
			}
			case DUP_X1:
			{	
				result = String.format("call stk := OpCode#DUPX1(stk);");
				break;
			}
			case FINDTYPE:
			{	
				FindtypeImpl tempInstr = (FindtypeImpl) instr;	
				String mm = tempInstr.getModelname();
				String cl = tempInstr.getTypename();
				result = String.format("call stk := OpCode#FINDTYPE(stk, _%s, _%s);", mm, cl);
				break;
			}
			case FINDTYPE_S:
			{	
				result = String.format("call stk := OpCode#FINDTYPE_S(stk);");
				break;
			}
			case GETENV:
			{	
				result = String.format("call stk := OpCode#GETENV(stk);");
				break;
			}
			case GETENVTYPE:
			{
				result = String.format("call stk := OpCode#GETENVTYPE(stk);");
				break;
			}
			case IFTE:
			{
				// THEN / ELSE CODE BLOCK SHOULD CONTAIN NO RETURN CLAUSE.
				IfteImpl tempInstr = (IfteImpl) instr;
				CodeBlock then = tempInstr.getThenCb();
				CodeBlock els = tempInstr.getElseCb();
				result = String.format("%s := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));\n", "cond#" + ln);
				result += String.format("call stk := OpCode#POP(stk);\n");
				result += String.format("if(cond#%d){", ln);
				printInstrs(then, localVars);
				result += "}else{\n";
				printInstrs(els, localVars);
				result += "}\n";
				break;
			}
			case ISNULL:
			{
				result = String.format("call stk := OpCode#ISNULL(stk);");
				break;
			}
			case NEW:
			{
				NewImpl tempInstr = (NewImpl) instr;	
				result = printNewInstr(ln, instrs, tempInstr.getModelname());
				break;
			}
			case NEW_S:
			{
				result = printNew_SInstr(ln, instrs);
				break;
			}
			case NOT:
			{
				result = String.format("call stk := OpCode#NOT(stk);");
				break;
			}
			case POP:
			{
				result = String.format("call stk := OpCode#POP(stk);");
				break;
			}
			case PUSH:
			{
				PushImpl tempInstr = (PushImpl) instr;	
				result = String.format("call stk := OpCode#PUSH(stk, %s);", "_" + tempInstr.getValue().toString());
				break;
			}
			case PUSHT:
			{
				result = String.format("call stk := OpCode#PUSHT(stk);");
				break;
			}
			case PUSHF:
			{
				result = String.format("call stk := OpCode#PUSHF(stk);");
				break;
			}
			case RETURN:
			{
				result = String.format("goto %s;", "label_END_"+cb.toString().replace(" ", "_")); 
				break;
			}
			case SWAP:
				result = String.format("call stk := OpCode#SWAP(stk);");
				break;
			case SWAP_X1:
			{
				result = String.format("call stk := OpCode#SWAPX1(stk);");
				break;
			}
			case XOR:
			{	
				result = String.format("call stk := OpCode#XOR(stk);");
				break;
			}
			default:
				result = String.format(instr.getOpcode() + " NOT SUPPORT");
				break;
			}	
		}
		

		result = String.format("%s\n", result);

		return result;
	}
	
	
	static String printNewInstr(int ln, List<Instruction> instrs, String mm) throws Exception {

		String operatedHeap = "???";
		String datatype = "???";
		
		Instruction prev1 = CodeBlockHelper.getInstrAt(instrs, ln - 1);

		if (prev1 instanceof PushImpl) {
			PushImpl op = (PushImpl) prev1;
			String mmName = op.getValue().toString();

			if (mmName.equals("#native")) {
				operatedHeap = "$linkHeap";
			} else {
				operatedHeap = tarHeap;
			}

		}

		String result = "assert Seq#Length(stk) >= 1;\n";
		result += String.format("havoc obj#%d;\n", ln);
		result += String.format("" + "assume obj#%d!= null && !read(%s, obj#%d, alloc) "
				+ "&& dtype(obj#%d) == classifierTable[_%s,"
				+ "($Unbox(Seq#Index(stk, Seq#Length(stk)-1)): String)];\n", ln, operatedHeap, ln, ln, mm);
		result += String.format("%s := update(%s, obj#%d, alloc, true);\n", operatedHeap, operatedHeap, ln);
		result += String.format("assume $IsGoodHeap(%s);\n", operatedHeap);
		result += String.format("assume $HeapSucc(old(%s), %s);\n", operatedHeap, operatedHeap);

		// establish injectivity between created target element and its
		// corresponding source element(s).
		if (operatedHeap.equals(tarHeap)) {
			String lhs = "";
			lhs = String.format("Seq#Singleton(%s)", inIds.get(0));
			for (String in : inIds.subList(1, inIds.size())) {
				lhs = String.format("Seq#Build(%s,%s)", lhs, in);
			}
			result += String.format("assume getTarsBySrcs(%s) == obj#%d;\n", lhs, ln);
		}
		result += String.format("stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(obj#%d));\n", ln);
		return result;
	}
	
	static String printNew_SInstr(int ln, List<Instruction> instrs) throws Exception {

		String operatedHeap = "???";
		String datatype = "???";
		
		Instruction prev1 = CodeBlockHelper.getInstrAt(instrs, ln - 1);

		if (prev1 instanceof PushImpl) {
			PushImpl op = (PushImpl) prev1;
			String mmName = op.getValue().toString();

			if (mmName.equals("#native")) {
				operatedHeap = "$linkHeap";
			} else {
				operatedHeap = tarHeap;
			}

		}

		String result = "assert Seq#Length(stk) >= 2;\n";
		result += String.format("havoc obj#%d;\n", ln);
		result += String.format("" + "assume obj#%d!= null && !read(%s, obj#%d, alloc) "
				+ "&& dtype(obj#%d) == classifierTable[($Unbox(Seq#Index(stk, Seq#Length(stk)-1)): String),"
				+ "($Unbox(Seq#Index(stk, Seq#Length(stk)-2)): String)];\n", ln, operatedHeap, ln, ln);
		result += String.format("%s := update(%s, obj#%d, alloc, true);\n", operatedHeap, operatedHeap, ln);
		result += String.format("assume $IsGoodHeap(%s);\n", operatedHeap);
		result += String.format("assume $HeapSucc(old(%s), %s);\n", operatedHeap, operatedHeap);

		// establish injectivity between created target element and its
		// corresponding source element(s).
		if (operatedHeap.equals(tarHeap)) {
			String lhs = "";
			lhs = String.format("Seq#Singleton(%s)", inIds.get(0));
			for (String in : inIds.subList(1, inIds.size())) {
				lhs = String.format("Seq#Build(%s,%s)", lhs, in);
			}
			result += String.format("assume getTarsBySrcs(%s) == obj#%d;\n", lhs, ln);
		}
		result += String.format("stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-2), $Box(obj#%d));\n", ln);
		return result;
	}

	static String printGetInstr(String operand, boolean isStatic) throws Exception {
		String operatedHeap = "???";
		String objType = typeStack.top().getVal();
		String fieldName = objType + "." + operand;

		fieldName = EcoreReaderHelper.getAbstractStructuralFeatureName(fieldName, objType, operand, srcsfInfo,
				tarsfInfo, parentInfo);

		if (ins.containsValue(objType)) {
			operatedHeap = "$srcHeap";
		} else if (outs.containsValue(objType)) {
			operatedHeap = tarHeap;
		} else {
			operatedHeap = "$linkHeap";
		}

		String result = "assert Seq#Length(stk) >= 1;\n";
		result += "assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;\n";
		if (!(operatedHeap.equals("$linkHeap") && operand.equals("links"))) {
			result += String.format("assert read(%s, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);\n",
					operatedHeap);
		}
		if(isStatic){
			result += String.format("stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(" + "read(%s,"
				+ "toRef($Unbox(Seq#Index(stk, Seq#Length(stk)-1)))," + "%s" + ")));\n", operatedHeap, fieldName);
		}else{
			result += String.format("stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(" + "read(%s,"
					+ "$Unbox(Seq#Index(stk, Seq#Length(stk)-1))," + "%s" + ")));\n", operatedHeap, fieldName);
		}
		return result;
	}


	static String printAddInstr(String operand) throws Exception {

		String objType = typeStack.get(typeStack.size() - 2).getVal();
		String fieldName = objType + "." + operand;

		String o = "$Unbox(Seq#Index(stk, Seq#Length(stk)-2))";
		String v = "$Unbox(Seq#Index(stk, Seq#Length(stk)-1))";
		
		fieldName = EcoreReaderHelper.getAbstractStructuralFeatureName(fieldName, objType, operand, srcsfInfo,
				tarsfInfo, parentInfo);

		String result = "assert Seq#Length(stk) > 1;\n";
		result += String.format("assert %s != null;\n", o);	
		result += String.format("assert read(%s, %s, alloc);\n", tarHeap, o);

		if (tarsfInfo.containsKey(fieldName) && tarsfInfo.get(fieldName).startsWith("Seq;")) { // isCollection
			result += "havoc $newCol;\n";
			result += "assume dtype($newCol) == class._System.array;\n";
			result += String.format("assume $newCol != null && read(%s, $newCol, alloc);\n", tarHeap);
			result += String.format(
					"assume Seq#FromArray(%s,$newCol) == Seq#Append(Seq#FromArray(%s, read(%s, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), %s)), Seq#FromArray(%s, $Unbox(Seq#Index(stk, Seq#Length(stk)-1))));\n",
					tarHeap, tarHeap, tarHeap, fieldName, tarHeap);
			result += String.format("%s := update(%s, %s, %s, $newCol);\n", tarHeap, tarHeap, o, fieldName);

		} else { // is normal field
			result += String.format("assert !isSet(acc, %s, %s)\n;", o, fieldName);
			result += String.format("%s := update(%s, %s, %s, %s);\n", tarHeap, tarHeap, o, fieldName, v);
			result += String.format("acc := set(acc, %s, %s, %s);\n", o, fieldName, "true");
		}

		result += String.format("assume $IsGoodHeap(%s);\n", tarHeap);
		result += "stk := Seq#Take(stk, Seq#Length(stk)-2);\n";
		return result;

	}


	static String printRemoveInstr(String operand) throws Exception {

		String objType = typeStack.get(typeStack.size() - 2).getVal();
		String fieldName = objType + "." + operand;

		String o = "$Unbox(Seq#Index(stk, Seq#Length(stk)-2))";
		String v = "$Unbox(Seq#Index(stk, Seq#Length(stk)-1))";
		fieldName = EcoreReaderHelper.getAbstractStructuralFeatureName(fieldName, objType, operand, srcsfInfo,
				tarsfInfo, parentInfo);

		String result = "assert Seq#Length(stk) > 1;\n";
		result += String.format("assert %s != null;\n", o);	
		result += String.format("assert read(%s, %s, alloc);\n", tarHeap, o);

		if (tarsfInfo.containsKey(fieldName) && tarsfInfo.get(fieldName).startsWith("Seq;")) { // isCollection
			result += "havoc $newCol;\n";
			result += "assume dtype($newCol) == class._System.array;\n";
			result += String.format("assume $newCol != null && read(%s, $newCol, alloc);\n", tarHeap);
			result += String.format(
					"assume (forall o: BoxType :: Seq#Contains(Seq#FromArray(%s,$newCol), o) <==> "
					+ "Seq#Contains(Seq#FromArray(%s, read(%s, %s, %s)), o) "
					+ "&& !Seq#Contains(Seq#FromArray(%s,%s), o));\n",
					tarHeap, tarHeap, tarHeap, o, fieldName, tarHeap, v);
			result += String.format(
					"%s := update(%s, %s, %s, $newCol);\n",
					tarHeap,tarHeap,o,fieldName);

		} else { // is normal field
			result += String.format("if(read(%s, %s, %s) == %s){\n", tarHeap, o, fieldName, v);
			
			result += String.format("assert isSet(acc, %s, %s);\n", o, fieldName);
			result += String.format("%s := update(%s, %s, %s, %s);\n", tarHeap,tarHeap,o, fieldName, v);
			result += String.format("acc := set(acc, %s, %s, %s);\n", o, fieldName, "false");
			result += "}\n";
			
		}

		result += String.format("assume $IsGoodHeap(%s);\n", tarHeap);
		result += "stk := Seq#Take(stk, Seq#Length(stk)-2);\n";
		return result;
		
		

	}


	static String printInsertInstr(String operand) throws Exception {

		String objType = typeStack.get(typeStack.size() - 3).getVal();
		String fieldName = objType + "." + operand;

		String o = "$Unbox(Seq#Index(stk, Seq#Length(stk)-3))";
		String v = "$Unbox(Seq#Index(stk, Seq#Length(stk)-2))";
		String i = "$Unbox(Seq#Index(stk, Seq#Length(stk)-1))";
		
		fieldName = EcoreReaderHelper.getAbstractStructuralFeatureName(fieldName, objType, operand, srcsfInfo,
				tarsfInfo, parentInfo);

		String result = "assert Seq#Length(stk) > 2;\n";
		result += String.format("assert %s != null;\n", o);	
		result += String.format("assert read(%s, %s, alloc);\n", tarHeap,o);
		
		if (tarsfInfo.containsKey(fieldName) && tarsfInfo.get(fieldName).startsWith("Seq;")) { // isCollection
			
			result += "havoc $newCol;\n";
			result += "assume dtype($newCol) == class._System.array;\n";
			result += String.format("assume $newCol != null && read(%s, $newCol, alloc);\n", tarHeap);
			result += String.format("assert -1 <= %s && %s < Seq#Length(Seq#FromArray(%s, read(%s, %s, %s)));", i, i, tarHeap,tarHeap,o, fieldName);
			result += String.format("assume Seq#FromArray(%s,$newCol) == Seq#Append(Seq#Append(Seq#Take(Seq#FromArray(%s, read(%s, %s, %s)), %s), Seq#FromArray(%s,%s)), Seq#Drop(Seq#FromArray(%s,read(%s, %s, %s)), %s));\n", tarHeap,tarHeap,tarHeap,o, fieldName, i, tarHeap,v, tarHeap,tarHeap,o, fieldName, i);
			result += String.format("%s := update(%s, %s, %s, $newCol);\n", tarHeap,tarHeap,o,fieldName);

		} else { // is normal field
			result += String.format("assert !isSet(acc, %s, %s)\n;", o, fieldName);
			result += String.format("%s := update(%s, %s, %s, %s);\n", tarHeap,tarHeap,o, fieldName, v);
			result += String.format("acc := set(acc, %s, %s, %s);\n", o, fieldName, "true");
			
		}

		result += String.format("assume $IsGoodHeap(%s);\n", tarHeap);
		result += "stk := Seq#Take(stk, Seq#Length(stk)-3);\n";
		return result;

	}

	static String printSetInstr(String operand, boolean isStatic) throws Exception {

		String objType = typeStack.get(typeStack.size() - 2).getVal();
		String fieldName = objType + "." + operand;

		fieldName = EcoreReaderHelper.getAbstractStructuralFeatureName(fieldName, objType, operand, srcsfInfo,
				tarsfInfo, parentInfo);

		String result = "assert Seq#Length(stk) >= 2;\n";
		result += "assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;\n";
		result += String.format("assert read(%s, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);\n", tarHeap);

		if(isStatic){
			result += String.format("%s := update(%s, " + "toRef($Unbox(Seq#Index(stk, Seq#Length(stk)-2))),"
					+ "%s," + "$Unbox(Seq#Index(stk, Seq#Length(stk)-1)));\n", tarHeap,tarHeap,fieldName);
		}else{
			result += String.format("%s := update(%s, " + "$Unbox(Seq#Index(stk, Seq#Length(stk)-2)),"
					+ "%s," + "$Unbox(Seq#Index(stk, Seq#Length(stk)-1)));\n", tarHeap,tarHeap,fieldName);
		}

		result += String.format("assume $IsGoodHeap(%s);\n", tarHeap);
		result += "stk := Seq#Take(stk, Seq#Length(stk)-2);\n";
		return result;

	}
	
	public static void genBoogie(String ATL, String module, String src, String srcId, String tar,
			String tarId, String out) throws Exception {
		env = ATLModelInjector.moduleLoader(ATL, module, src, tar, srcId, tarId);	// EMF_Env
		srcMM = EcoreReaderHelper.readEcore(src);
		tarMM = EcoreReaderHelper.readEcore(tar);

		parentInfo.putAll(EcoreReaderHelper.readParantInfo(srcMM));
		parentInfo.putAll(EcoreReaderHelper.readParantInfo(tarMM));

		srcsfInfo.putAll(EcoreReaderHelper.readEinfoAll(srcMM));
		tarsfInfo.putAll(EcoreReaderHelper.readEinfoAll(tarMM));
		

		
		for(Rule rl : env.getRules()){
			CodeBlock cb_match = rl.getMatcher();
			if(cb_match != null){
				
				if(rl.getMode() == RuleMode.AUTOMATIC_RECURSIVE){
					tarHeap = "$srcHeap";
				}else{
					tarHeap = "$tarHeap";
				}
				
				rule = rl.getName();
				option = "match";
				//String outPth = String.format("%s%s_match.bpl", out, rule);
				//System.setOut(new PrintStream(new File(outPth)));
				bootstrap_miningATLSource(rule);
				printSignature(rule, option);
				printCodeBlock(cb_match, option);
			}
			
			CodeBlock cb_apply = rl.getApplier();
			if(cb_apply != null){
				rule = rl.getName();
				option = "apply";
				//String outPth = String.format("%s%s_match.bpl", out, rule);
				//System.setOut(new PrintStream(new File(outPth)));
				bootstrap_miningATLSource(rule);
				printSignature(rule, option);
				printCodeBlock(cb_apply, option);
			}
			
			
		}
		
	}

	
	static void printSignature(String rule, String option) {
		if (option.equals("apply")) {
			System.out.printf("implementation %s_apply (in: ref) returns ()", rule);
		} else {
			System.out.printf("implementation %s_matchAll() returns ()", rule);
		}

		System.out.println();
	}
	
	static void printCodeBlock(CodeBlock cb, String option) throws Exception {
		System.out.println("{\n");
		Map<String, String> localVars = printLocalVars(cb, option);
		printInstrs(cb, localVars);
		System.out.printf("label_END_%s:\n", cb.toString().replace(" ", "_"));	// hack, should be in bootstrap_getLabels
		System.out.println("\n}");

	}
	
	
	static Map<String, String> printLocalVars(CodeBlock cb, String option) throws Exception {

		System.out.printf("var %s: Seq BoxType;\n", "stk");
		System.out.printf("var %s: ref;\n", "$newCol");
		// for apply operation, there is a implicit copy: link := in;
		if (option.equals("apply")) {
			System.out.println("__trace__ := in;");
		}
		
		for (LocalVariable v : cb.getLocalVariables()) {
			System.out.printf("var %s: ref;\t//slot: %s\n", v.getName(), v.getSlot());
			localVars.put(Integer.toString(v.getSlot()), v.getName());
		}

		//TODO bootstrap the localvars of other code block, if, iter etc.
		bootstrap_addNewVars(cb);
		
		// for all operation, initialize the local operand stack;
		System.out.printf("%s := %s();\n", "stk", "OpCode#Aux#InitStk");
		

		
		System.out.println();
		return localVars;
	}
	
	static void printInstrs(CodeBlock cb, Map<String, String> localVars) throws Exception {
		int ln = 0;

		Set<Integer> labelsPool = bootstrap_getLabels(cb);

		typeStack = new TypeStack(localVars, ins, outs, srcsfInfo, tarsfInfo, parentInfo);

		for (Instruction instr : cb.getCode()) {
			

			// print extra label, if any.
			if (labelsPool.contains(ln)) {
				System.out.printf("label_%d:\n", ln);
			}

			// print instr
			System.out.print(printInstr(instr, localVars, ln, cb, cb.getCode()));

			// acts on the type stack
			typeStack.act(instr);
			ln++;
		}

		// print the last statement, equiv to return. put postcondition check
		// here if necessary.
		if (labelsPool.contains(ln)) {
			System.out.printf("label_%d:\n", ln);
		}
	}
	
	static void bootstrap_miningATLSource(String rule) throws Exception {

		inIds.clear();
		Rule r = getRule(env, rule);
		if (r == null) {
			throw new Exception("No rule found with given name: " + rule);
		}

		for (InputRuleElement i : r.getInputElements()) {
			ins.put(i.getName(), String.format("%s$%s", i.getTypeModel(), i.getType()));
			inIds.add(i.getName());
		}

		for (OutputRuleElement o : r.getOutputElements()) {
			outs.put(o.getName(), String.format("%s$%s", o.getTypeModel(), o.getType()));
			outTypes.add(String.format("%s$%s", o.getTypeModel(), o.getType()));
		}

		System.out.println();

	}
	
	static Rule getRule(ExecEnv env, String rule) {
		for (Rule r : env.getRules()) {
			if (r.getName().equals(rule)) {
				return r;
			}
		}
		return null;
	}

	public static void main(String[] args) throws Exception {

		genBoogie(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);

	}




}
