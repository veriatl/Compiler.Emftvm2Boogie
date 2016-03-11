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
import org.eclipse.m2m.atl.emftvm.Opcode;
import org.eclipse.m2m.atl.emftvm.OutputRuleElement;
import org.eclipse.m2m.atl.emftvm.Rule;


import org.eclipse.m2m.atl.emftvm.impl.*;


import org.eclipse.m2m.atl.engine.vm.ASMInstruction;
import org.eclipse.m2m.atl.engine.vm.ASMInstructionWithOperand;
import org.eclipse.m2m.atl.engine.vm.ASMOperation;
import org.eclipse.m2m.atl.engine.vm.ASMOperation.LocalVariableEntry;

import fr.emn.atlanmod.emftvm2boogie.helper.ASMReaderHelper;
import fr.emn.atlanmod.emftvm2boogie.helper.ATLModelInjector;
import fr.emn.atlanmod.emftvm2boogie.helper.EcoreReaderHelper;
import fr.emn.atlanmod.emftvm2boogie.helper.TypeStack;


public class emftvm2boogieDriver {

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

	static void printSignature(String rule, String option) {
		if (option.equals("apply")) {
			System.out.printf("implementation %s_apply (in: ref) returns ()", rule);
		} else {
			System.out.printf("implementation %s_matchAll() returns ()", rule);
		}

		System.out.println();
	}
	
	static void printCodeBlock(CodeBlock cb) throws Exception {
		System.out.println("{\n");
		Map<String, String> localVars = printLocalVars(cb);
		printInstrs(cb, localVars);
		System.out.println("\n}");

	}
	
	static Map<String, String> printLocalVars(CodeBlock cb) throws Exception {

		System.out.printf("var %s: Seq BoxType;\n", "stk");

		System.out.printf("var %s: ref;\n", "$newCol");



		System.out.println();
		return localVars;
	}
	

	static void printInstrs(CodeBlock cb, Map<String, String> localVars) throws Exception {
		int ln = 0;

//		Set<Integer> labelsPool = bootstrap_getLabels(op);

		typeStack = new TypeStack(localVars, ins, outs, srcsfInfo, tarsfInfo, parentInfo);

		for (Instruction instr : cb.getCode()) {
			

			// print extra label, if any.
//			if (labelsPool.contains(ln)) {
//				System.out.printf("label_%d:\n", ln);
//			}

			// print instr
			System.out.print(printInstr(instr, localVars, ln, cb.getCode()));

			// acts on the type stack
//			typeStack.act(instr);
			ln++;
		}

		// print the last statement, equiv to return. put postcondition check
		// here if necessary.
//		if (labelsPool.contains(ln)) {
//			System.out.printf("label_%d:\n", ln);
//		}
	}
	
	/*
	 * instr: the instruction localVars: local variables table ln : lint number
	 */
	static String printInstr(Instruction instr, Map<String, String> localVars, int ln, List<Instruction> instrs)
			throws Exception {
		String result = "";
		
		if (instr instanceof FieldInstructionImpl) {
			FieldInstructionImpl instro = (FieldInstructionImpl) instr;

			switch (instro.getOpcode()) {
			case ADD:
			{
				break;
			}
			case GET:
			{
	//			result = printGetInstr(operand);
				break;
			}
			case GET_STATIC:
			{
	//			result = printGetInstr(operand);
				break;
			}
			case INSERT:
			{
				
				break;
			}
			case REMOVE:
			{
				
				break;
			}
			case SET:
	//			result = printSetInstr(operand);
				break;
			case SET_STATIC:
			{
				
				break;
			}
			default:
				result = String.format(instr.getOpcode() + " NOT SUPPORT");
				break;
			}
		}else if(instr instanceof LocalVariableInstructionImpl){
			switch (instr.getOpcode()) {
			case STORE:
			{	
				String var_store = localVars.get(((LocalVariableInstructionImpl) instr).getLocalVariable());
				result = String.format("call stk, %s := OpCode#STORE(stk);", var_store);
				break;
			}
			case LOAD:
			{	
				String var_load = localVars.get(((LocalVariableInstructionImpl) instr).getLocalVariable());
				result = String.format("call stk := OpCode#LOAD(stk, %s);", var_load);
				break;
			}
			default:
			{	
				result = String.format(instr.getOpcode() + " NOT SUPPORT");
				break;
			}
			}
		}else if(instr instanceof BranchInstructionImpl){
			switch (instr.getOpcode()) {
			case ENDITERATE:
			{
				String counter1 = enditeratorMap.get(ln);
				int conterLN = Integer.parseInt(counter1.substring(counter1.indexOf("#") + 1));
				result += String.format("%s := %s+1;\n", counter1, counter1);
				result = result + String.format("assert 0<= decreases#%d || Seq#Length(obj#%d) - %s == decreases#%d;\n", Integer.valueOf(conterLN), Integer.valueOf(conterLN - 1), counter1, Integer.valueOf(conterLN));
		        result = result + String.format("assert Seq#Length(obj#%d) - %s < decreases#%d;\n", Integer.valueOf(conterLN - 1), counter1, Integer.valueOf(conterLN) );
				result += String.format("}");
				loopLevel--;
				break;
			}
			case GOTO:
			{
				int operand = ((BranchInstructionImpl) instr).getOffset();
				result = String.format("goto %s;", "label_" + Integer.toString(operand));
				break;
			}
			case IF:
			{	
				int operand = ((BranchInstructionImpl) instr).getOffset();
				result = String.format("%s := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));\n", "cond#" + ln);
				result += String.format("call stk := OpCode#POP(stk);\n");
				result += String.format("if(cond#%d){goto %s;}", ln, "label_" + Integer.toString(operand));
				break;
			}
			case IFN: 
			{
				int operand = ((BranchInstructionImpl) instr).getOffset();
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
			switch (instr.getOpcode()) {
			case AND:
			{
				//
				break;
			}
			case IMPLIES:
			{
				//
				break;
			}
			case INVOKE_CB:
			{
				//
				break;
			}
			case OR:
			{
				//
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
				//
				break;
			}
			case INVOKE:
			{
//				result = ASMReaderHelper.genCallwithReturns(operand, ln, typeStack);
				break;
			}
			case INVOKE_STATIC:
			{
				//
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
				//TODO, determine heap
				result = String.format("call stk := OpCode#ALLINST(stk, ???);");
				break;
			}
			case ALLINST_IN:
			{
				result = String.format("call stk := OpCode#ALLINST_IN(stk);");
				break;
			}
			case DELETE :
			{
				//
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
				//
				break;
			}
			case ISNULL:
			{
				result = String.format("call stk := OpCode#ISNULL(stk);");
				break;
			}
			case NEW:
			{
//				result = printNewInstr(ln, instrs);
				break;
			}
			case NEW_S:
			{
				//
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
				result = String.format("call stk := OpCode#PUSHF(stk);");
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
		

		
		
//		if (instr instanceof ASMInstructionWithOperand) { // case of instr with
//															// operand
//			ASMInstructionWithOperand instro = (ASMInstructionWithOperand) instr;
//			String operand = instro.getOperand();
//			switch (instro.getMnemonic().toLowerCase()) {
//			case "push":
//				result = String.format("call stk := OpCode#Push(stk, %s);", "_" + operand);
//				break;
//			case "pushi":
//				result = String.format("call stk := OpCode#Pushi(stk, %s);", operand);
//				break;
//			case "store":
//				String var_store = localVars.get(operand);
//				result = String.format("call stk, %s := OpCode#Store(stk);", var_store);
//				break;
//			case "load":
//				String var_load = localVars.get(operand);
//				result = String.format("call stk := OpCode#Load(stk, %s);", var_load);
//				break;
//			case "if":
//				result = String.format("%s := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));\n", "cond#" + ln);
//				result += String.format("call stk := OpCode#Pop(stk);\n");
//				result += String.format("if(cond#%d){goto %s;}", ln, "label_" + operand);
//				break;
//			case "goto":
//				result = String.format("goto %s;", "label_" + operand);
//				break;
//			case "call":
//				result = ASMReaderHelper.genCallwithReturns(operand, ln, typeStack);
//				break;
//			case "pcall":
//				result = ASMReaderHelper.genVoidCall(operand, ln);
//				break;
//			case "set":
////				result = printSetInstr(operand);
//				break;
//			case "get":
////				result = printGetInstr(operand);
//				break;
//			default:
//				result = String.format(instro.getMnemonic() + " error");
//				break;
//			}
//
//		} else { // case of instr without operand
//			switch (instr.getMnemonic().toLowerCase()) {
//			case "pusht":
//				result = String.format("call stk := OpCode#Pusht(stk);");
//				break;
//			case "pushf":
//				result = String.format("call stk := OpCode#Pushf(stk);");
//				break;
//			case "pop":
//				result = String.format("call stk := OpCode#Pop(stk);");
//				break;
//			case "swap":
//				result = String.format("call stk := OpCode#Swap(stk);");
//				break;
//			case "dup":
//				result = String.format("call stk := OpCode#Dup(stk);");
//				break;
//			case "dup_x1":
//				result = String.format("call stk := OpCode#DupX1(stk);");
//				break;
//			case "iterate":
//				String counter = iteratorMap.get(ln);
//				result += String.format("obj#%d := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));\n", ln - 1);
//				result += String.format("%s:=0;\n", counter);
//				result += String.format("call stk := OpCode#Pop(stk);\n");
//				result += String.format("while(%s<Seq#Length(obj#%d)) \n", counter, ln - 1);
//				for (String inv : invPool.get(loopLevel)) {
//					result += inv;
//				}
//				result = result + String.format("{ decreases#%d := Seq#Length(obj#%d) - %s;\n", Integer.valueOf(ln), Integer.valueOf(ln - 1), counter );
//				result += String.format("stk := Seq#Build(stk, $Box(Seq#Index(obj#%d, %s)));", ln - 1, counter);
//				loopLevel++;
//				break;
//			case "enditerate":
//				String counter1 = enditeratorMap.get(ln);
//				int conterLN = Integer.parseInt(counter1.substring(counter1.indexOf("#") + 1));
//				result += String.format("%s := %s+1;\n", counter1, counter1);
//				result = result + String.format("assert 0<= decreases#%d || Seq#Length(obj#%d) - %s == decreases#%d;\n", Integer.valueOf(conterLN), Integer.valueOf(conterLN - 1), counter1, Integer.valueOf(conterLN));
//		        result = result + String.format("assert Seq#Length(obj#%d) - %s < decreases#%d;\n", Integer.valueOf(conterLN - 1), counter1, Integer.valueOf(conterLN) );
//				result += String.format("}");
//				loopLevel--;
//				break;
//			case "new":
//				result = printNewInstr(ln, instrs);
//				break;
//			case "findme":
//				result = String.format("call stk := OpCode#Findme(stk);");
//				break;
//			case "getasm":
//				result = String.format("call stk := OpCode#GetASM(stk);");
//				break;
//			default:
//				result = String.format(instr.getMnemonic() + " error");
//				break;
//			}
//		}
		result = String.format("%s\n", result);

		return result;
	}
	
	public static void genBoogie(String ATL, String module, String src, String srcId, String tar,
			String tarId, String out) throws Exception {
		env = ATLModelInjector.moduleLoader(ATL, module, src, tar, srcId, tarId);
		srcMM = EcoreReaderHelper.readEcore(src);
		tarMM = EcoreReaderHelper.readEcore(tar);

		attrInfo.putAll(EcoreReaderHelper.readEinfo(srcMM));
		attrInfo.putAll(EcoreReaderHelper.readEinfo(tarMM));

		parentInfo.putAll(EcoreReaderHelper.readParantInfo(srcMM));
		parentInfo.putAll(EcoreReaderHelper.readParantInfo(tarMM));

		srcsfInfo.putAll(EcoreReaderHelper.readEinfoAll(srcMM));
		tarsfInfo.putAll(EcoreReaderHelper.readEinfoAll(tarMM));
		
		for(Rule rl : env.getRules()){
			CodeBlock cb_match = rl.getMatcher();
			if(cb_match != null){
				rule = rl.getName();
				option = "match";
				//String outPth = String.format("%s%s_match.bpl", out, rule);
				//System.setOut(new PrintStream(new File(outPth)));
				//bootstrap_miningATLSource(rule);
//				printSignature(rule, option);
//				printCodeBlock(cb_match);
			}
			
			CodeBlock cb_apply = rl.getApplier();
			if(cb_apply != null){
				rule = rl.getName();
				option = "apply";
				//String outPth = String.format("%s%s_match.bpl", out, rule);
				//System.setOut(new PrintStream(new File(outPth)));
				//bootstrap_miningATLSource(rule);
				printSignature(rule, option);
				printCodeBlock(cb_apply);
			}
			
			
		}
		
	}

	public static void main(String[] args) throws Exception {

		genBoogie(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);

	}




}
