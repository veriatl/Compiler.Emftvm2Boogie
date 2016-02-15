package fr.emn.atlanmod.emftvm2boogie.core;

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
import org.eclipse.m2m.atl.emftvm.OutputRuleElement;
import org.eclipse.m2m.atl.emftvm.Rule;
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
			for(Instruction instr : cb_match.getCode()){
				
			}
		}
		
	}

	public static void main(String[] args) throws Exception {

		genBoogie(args[1], args[2], args[3], args[4], args[5], args[6], args[7]);

	}

	static void printOperation(ASMOperation op) throws Exception {
		System.out.println("{\n");
		Map<String, String> localVars = printLocalVars(op);
		printInstrs(op, localVars);
		System.out.println("\n}");

	}

	
	static void printSignature(String rule, String option) {
		if (option.equals("apply")) {
			System.out.printf("implementation %s_apply (in: ref) returns ()", rule);
		} else {
			System.out.printf("implementation %s_matchAll() returns ()", rule);
		}

		System.out.println();
	}

	static Map<String, String> printLocalVars(ASMOperation op) throws Exception {

		System.out.printf("var %s: Seq BoxType;\n", "stk");

		System.out.printf("var %s: ref;\n", "$newCol");

		for (Object v : op.getLocalVariableTable()) {
			LocalVariableEntry var = (LocalVariableEntry) v;
			System.out.printf("var %s: ref;\t//slot: %s\n", var.name, var.slot);
			localVars.put(Integer.toString(var.slot), var.name);
		}

		// preprocess to declare additional local vars, e.g. for new
		// instruction, or return result of functions, or iterate
		bootstrap_newVars(op);

		// for all operation, initialize the local operand stack;
		System.out.printf("%s := %s();\n", "stk", "OpCode#Aux#InitStk");

		// for apply operation, there is a implicit copy: link := in;
		if (op.getName().startsWith("__apply")) {
			System.out.println("link := in;");
		}

		System.out.println();
		return localVars;
	}

	static void printInstrs(ASMOperation op, Map<String, String> localVars) throws Exception {
		int ln = 0;

		Set<Integer> labelsPool = bootstrap_getLabels(op);

		typeStack = new TypeStack(localVars, ins, outs, srcsfInfo, tarsfInfo, parentInfo);

		for (Object instruction : op.getInstructions()) {
			ASMInstruction instr = (ASMInstruction) instruction;

			// print extra label, if any.
			if (labelsPool.contains(ln)) {
				System.out.printf("label_%d:\n", ln);
			}

			// print instr
			System.out.print(printInstr(instr, localVars, ln, op.getInstructions()));
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

	static Set<Integer> bootstrap_getLabels(ASMOperation op) {
		int ln = 0;
		HashSet<Integer> set = new HashSet<Integer>();

		for (Object instruction : op.getInstructions()) {
			ASMInstruction instr = (ASMInstruction) instruction;
			if (instr instanceof ASMInstructionWithOperand) {
				ASMInstructionWithOperand instro = (ASMInstructionWithOperand) instr;
				String operand = instro.getOperand();
				switch (instro.getMnemonic().toLowerCase()) {
				case "goto":
					set.add(Integer.parseInt(operand));
					break;
				case "if":
					set.add(Integer.parseInt(operand));
					set.add(ln + 1);
					break;
				default:
					break;
				}
			}
			ln++;
		}

		return set;
	}

	static String genIndexInvariant(String counter, String col) {
		return String.format("invariant %s <= Seq#Length(%s);\n", counter, col);
	}

	static String genContainmentInvariant(String counter, String col, List<InputRuleElement> ins) {
		InputRuleElement elem = ins.get(loopLevel);
		String eName = elem.getName();
		String eClassifier = elem.getType();
		String eMetaName = elem.getTypeModel();

		String bv = "_" + eName;
		String bvType = eMetaName + "$" + eClassifier;

		String rtn = String.format(
				"invariant (forall %s: ref :: "
						+ "%s != null && read($srcHeap, %s, alloc) && dtype(%s) <: %s ==> Seq#Contains(%s,%s));\n",
				bv, bv, bv, bv, bvType, col, bv);
		return rtn;

	}

	static String genEffectInvariantOutputConstraint(String counter, String col, List<InputRuleElement> ins) {
		String rtn = "";

		List<String> inputString = new ArrayList<String>();

		for (String ct : iteratorStack.subList(0, loopLevel)) {
			int lnPrev = Integer.parseInt(ct.substring(ct.indexOf("#") + 1));
			String colPrev = "obj#" + (lnPrev - 1);
			String sPrev = String.format("Seq#Index(%s,%s)", colPrev, ct);
			inputString.add(sPrev);
		}

		String bvCounter = "_" + counter;
		String curr = String.format("Seq#Index(%s,%s)", col, bvCounter);
		inputString.add(curr);

		List<InputRuleElement> rest = ins.subList(loopLevel + 1, ins.size());

		for (InputRuleElement r : rest) {
			String rName = "__" + r.getName();
			inputString.add(rName);
		}

		String tar = String.format("Seq#Singleton(%s)", inputString.get(0));

		for (String rezt : inputString.subList(1, inputString.size())) {
			tar = String.format("Seq#Build(%s, %s)", tar, rezt);
		}

		tar = String.format("getTarsBySrcs(%s)", tar);

		List<OutputRuleElement> outs = getRuleTarElements(getRule(env, rule));
		OutputRuleElement o = outs.get(0);
		String tarType = o.getTypeModel() + "$" + o.getType();

		String first = String.format("%s != null &&", tar);
		String second = String.format("read($tarHeap, %s, alloc) && ", tar);
		String third = String.format("dtype(%s) <: %s", tar, tarType);

		rtn = first + second + third;

		return rtn;
	}

	// Note: the guard body is stored as a Boogie function.
	// Generated by the Match_ATL2Boogie XPand template.
	static String genGuardSignature(String counter, String col, List<InputRuleElement> ins) {
		String rtn = String.format("printGuard_%s($srcHeap,", rule);

		List<String> inputString = new ArrayList<String>();

		for (String ct : iteratorStack.subList(0, loopLevel)) {
			int lnPrev = Integer.parseInt(ct.substring(ct.indexOf("#") + 1));
			String colPrev = "obj#" + (lnPrev - 1);
			String sPrev = String.format("Seq#Index(%s,%s)", colPrev, ct);
			inputString.add(sPrev);
		}

		String bvCounter = "_" + counter;
		String curr = String.format("Seq#Index(%s,%s)", col, bvCounter);
		inputString.add(curr);

		List<InputRuleElement> rest = ins.subList(loopLevel + 1, ins.size());

		for (InputRuleElement r : rest) {
			String rName = "__" + r.getName();
			inputString.add(rName);
		}

		int idx = 0;
		for (String elem : inputString) {
			rtn += elem;
			if (idx < inputString.size() - 1) {
				rtn += ",";
			}
			idx++;
		}

		rtn += ")";
		return rtn;
	}

	static String genEffectInvariant(String counter, String col, List<InputRuleElement> ins) {
		String bvCounter = "_" + counter;
		String rtn = String.format("invariant (forall %s: int :: 0<= %s && %s< %s ==> true ==> ", bvCounter, bvCounter,
				bvCounter, counter);

		InputRuleElement elem = ins.get(loopLevel);

		String eName = elem.getName();
		String eClassifier = elem.getType();
		String eMetaName = elem.getTypeModel();

		String bv = "_" + eName;
		String bvType = eMetaName + "$" + eClassifier;

		rtn += String.format(
				"(Seq#Index(%s,%s)!=null && read($srcHeap, Seq#Index(%s,%s), alloc) && dtype(Seq#Index(%s,%s)) <: %s ==>",
				col, bvCounter, col, bvCounter, col, bvCounter, bvType);

		List<InputRuleElement> rest = ins.subList(loopLevel + 1, ins.size());

		if (rest.size() != 0) {
			rtn += " (forall ";
			int sep = 0;
			for (InputRuleElement ip : rest) {
				rtn += "__" + ip.getName();
				if (sep < rest.size() - 1) {
					rtn += ",";
				}
				sep++;
			}
			rtn += ":ref :: ";

			sep = 0;
			for (InputRuleElement ip : rest) {
				String fvName = "__" + ip.getName();
				String fvType = ip.getTypeModel() + "$" + ip.getType();

				rtn += String.format("Seq#Contains(Fun#LIB#AllInstanceFrom(old($srcHeap),%s),%s)", fvType, fvName);
				if (sep < rest.size() - 1) {
					rtn += " && ";
				}
				sep++;
			}
			rtn += " ==> ";
		}

		rtn += genGuardSignature(counter, col, ins);
		rtn += " ==> ";
		rtn += genEffectInvariantOutputConstraint(counter, col, ins);

		if (rest.size() != 0) {
			rtn += ")";
		}

		rtn += "));\n";
		return rtn;
	}

	static String genFrameCondition(String counter, String col, List<InputRuleElement> ins) throws Exception {
		List<OutputRuleElement> outs = getRuleTarElements(getRule(env, rule));
		if (outs.size() == 0) {
			throw new Exception("no output element");
		}

		OutputRuleElement o = outs.get(0);
		String oType = o.getTypeModel() + "$" + o.getType();

		int insSize = ins.size();

		String rtn = String.format("invariant (forall<alpha> $o : ref, $f: Field alpha :: ($o == null "
				+ "|| read($tarHeap, $o, $f) == read(old($tarHeap), $o, $f) "
				+ "|| ((dtype($o) <: %s) && Seq#Length(getTarsBySrcs_inverse($o)) == %d ", oType, insSize);

		int idx = 0;
		for (InputRuleElement i : ins) {
			String iType = i.getTypeModel() + "$" + i.getType();
			rtn += String.format("&& dtype(Seq#Index(getTarsBySrcs_inverse($o), %d)) <: %s ", idx, iType);

			idx++;
		}

		rtn += "&& $f==alloc )));\n";
		return rtn;

	}

	static List<String> genInvariant(String counter, String col) throws Exception {
		List<InputRuleElement> elems = getRuleSrcElements(getRule(env, rule));

		ArrayList<String> rtn = new ArrayList<String>();
		if (invPool.containsKey(loopLevel - 1)) {
			rtn.addAll(invPool.get(loopLevel - 1));
		}
		rtn.add(genIndexInvariant(counter, col));
		rtn.add(genContainmentInvariant(counter, col, elems));
		rtn.add(genEffectInvariant(counter, col, elems));

		if (loopLevel == 0) {
			rtn.add(genFrameCondition(counter, col, elems));
		}
		return rtn;
	}

	static void bootstrap_newVars(ASMOperation op) throws Exception {
		int ln = 0;
		for (Object instruction : op.getInstructions()) {
			ASMInstruction instr = (ASMInstruction) instruction;
			switch (instr.getMnemonic().toLowerCase()) {
			case "new":
				System.out.printf("var obj#%d: ref;\n", ln);
				break;
			case "iterate":
				String col = String.format("obj#%d", ln - 1);
				String counter = String.format("$counter#%d", ln);
				System.out.printf("var %s: Seq ref;\n", col);
				System.out.printf("var %s: int;\n", counter);
				System.out.printf("var decreases#%s: int;\n", Integer.valueOf(ln) );
				iteratorStack.push(counter);
				iteratorMap.put(ln, counter);
				invPool.put(loopLevel, genInvariant(counter, col));
				loopLevel++;
				break;
			case "enditerate":
				enditeratorMap.put(ln, iteratorStack.pop());
				loopLevel--;
				break;
			case "if":
				System.out.printf("var cond#%d: bool;\n", ln);
			default:
				break;
			}

			ln++;
		}

	}

	/*
	 * instr: the instruction localVars: local variables table ln : lint number
	 */
	static String printInstr(ASMInstruction instr, Map<String, String> localVars, int ln, List<ASMInstruction> instrs)
			throws Exception {
		String result = "";
		if (instr instanceof ASMInstructionWithOperand) { // case of instr with
															// operand
			ASMInstructionWithOperand instro = (ASMInstructionWithOperand) instr;
			String operand = instro.getOperand();
			switch (instro.getMnemonic().toLowerCase()) {
			case "push":
				result = String.format("call stk := OpCode#Push(stk, %s);", "_" + operand);
				break;
			case "pushi":
				result = String.format("call stk := OpCode#Pushi(stk, %s);", operand);
				break;
			case "store":
				String var_store = localVars.get(operand);
				result = String.format("call stk, %s := OpCode#Store(stk);", var_store);
				break;
			case "load":
				String var_load = localVars.get(operand);
				result = String.format("call stk := OpCode#Load(stk, %s);", var_load);
				break;
			case "if":
				result = String.format("%s := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));\n", "cond#" + ln);
				result += String.format("call stk := OpCode#Pop(stk);\n");
				result += String.format("if(cond#%d){goto %s;}", ln, "label_" + operand);
				break;
			case "goto":
				result = String.format("goto %s;", "label_" + operand);
				break;
			case "call":
				result = ASMReaderHelper.genCallwithReturns(operand, ln, typeStack);
				break;
			case "pcall":
				result = ASMReaderHelper.genVoidCall(operand, ln);
				break;
			case "set":
				result = printSetInstr(operand);
				break;
			case "get":
				result = printGetInstr(operand);
				break;
			default:
				result = String.format(instro.getMnemonic() + " error");
				break;
			}

		} else { // case of instr without operand
			switch (instr.getMnemonic().toLowerCase()) {
			case "pusht":
				result = String.format("call stk := OpCode#Pusht(stk);");
				break;
			case "pushf":
				result = String.format("call stk := OpCode#Pushf(stk);");
				break;
			case "pop":
				result = String.format("call stk := OpCode#Pop(stk);");
				break;
			case "swap":
				result = String.format("call stk := OpCode#Swap(stk);");
				break;
			case "dup":
				result = String.format("call stk := OpCode#Dup(stk);");
				break;
			case "dup_x1":
				result = String.format("call stk := OpCode#DupX1(stk);");
				break;
			case "iterate":
				String counter = iteratorMap.get(ln);
				result += String.format("obj#%d := $Unbox(Seq#Index(stk, Seq#Length(stk)-1));\n", ln - 1);
				result += String.format("%s:=0;\n", counter);
				result += String.format("call stk := OpCode#Pop(stk);\n");
				result += String.format("while(%s<Seq#Length(obj#%d)) \n", counter, ln - 1);
				for (String inv : invPool.get(loopLevel)) {
					result += inv;
				}
				result = result + String.format("{ decreases#%d := Seq#Length(obj#%d) - %s;\n", Integer.valueOf(ln), Integer.valueOf(ln - 1), counter );
				result += String.format("stk := Seq#Build(stk, $Box(Seq#Index(obj#%d, %s)));", ln - 1, counter);
				loopLevel++;
				break;
			case "enditerate":
				String counter1 = enditeratorMap.get(ln);
				int conterLN = Integer.parseInt(counter1.substring(counter1.indexOf("#") + 1));
				result += String.format("%s := %s+1;\n", counter1, counter1);
				result = result + String.format("assert 0<= decreases#%d || Seq#Length(obj#%d) - %s == decreases#%d;\n", Integer.valueOf(conterLN), Integer.valueOf(conterLN - 1), counter1, Integer.valueOf(conterLN));
		        result = result + String.format("assert Seq#Length(obj#%d) - %s < decreases#%d;\n", Integer.valueOf(conterLN - 1), counter1, Integer.valueOf(conterLN) );
				result += String.format("}");
				loopLevel--;
				break;
			case "new":
				result = printNewInstr(ln, instrs);
				break;
			case "findme":
				result = String.format("call stk := OpCode#Findme(stk);");
				break;
			case "getasm":
				result = String.format("call stk := OpCode#GetASM(stk);");
				break;
			default:
				result = String.format(instr.getMnemonic() + " error");
				break;
			}
		}
		result = String.format("%s\n", result);

		return result;
	}

	static Rule getRule(ExecEnv env, String rule) {
		for (Rule r : env.getRules()) {
			if (r.getName().equals(rule)) {
				return r;
			}
		}
		return null;
	}

	static List<InputRuleElement> getRuleSrcElements(Rule r) {
		return r.getInputElements();
	}

	static List<OutputRuleElement> getRuleTarElements(Rule r) {
		return r.getOutputElements();
	}

	static ASMInstruction getInstrAt(List<ASMInstruction> instrs, int ln) {

		int i = 0;
		for (ASMInstruction instr : instrs) {
			if (i == ln) {
				return instr;
			}
			i++;
		}
		return null;
	}

	static String printNewInstr(int ln, List<ASMInstruction> instrs) throws Exception {

		String operatedHeap = "???";
		String datatype = "???";
		ASMInstruction prev1 = getInstrAt(instrs, ln - 1);

		if (prev1 instanceof ASMInstructionWithOperand && prev1.getMnemonic().toLowerCase().equals("push")) {
			ASMInstructionWithOperand prev1o = (ASMInstructionWithOperand) prev1;
			String prev1op = prev1o.getOperand();

			if (prev1op.equals("#native")) {
				operatedHeap = "$linkHeap";
			} else {
				operatedHeap = "$tarHeap";
			}

		}

		// todo: treate set, seq.. collection differently
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
		if (operatedHeap.equals("$tarHeap")) {
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

	static String printGetInstr(String operand) throws Exception {
		String operatedHeap = "???";
		String objType = typeStack.top().getVal();
		String fieldName = objType + "." + operand;

		fieldName = EcoreReaderHelper.getAbstractStructuralFeatureName(fieldName, objType, operand, srcsfInfo,
				tarsfInfo, parentInfo);

		if (ins.containsValue(objType)) {
			operatedHeap = "$srcHeap";
		} else if (outs.containsValue(objType)) {
			operatedHeap = "$tarHeap";
		} else {
			operatedHeap = "$linkHeap";
		}

		String result = "assert Seq#Length(stk) >= 1;\n";
		result += "assert $Unbox(Seq#Index(stk, Seq#Length(stk)-1)) != null;\n";
		if (!(operatedHeap.equals("$linkHeap") && operand.equals("links"))) {
			result += String.format("assert read(%s, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)),alloc);\n",
					operatedHeap);
		}
		result += String.format("stk := Seq#Build(Seq#Take(stk, Seq#Length(stk)-1), $Box(" + "read(%s,"
				+ "$Unbox(Seq#Index(stk, Seq#Length(stk)-1))," + "%s" + ")));", operatedHeap, fieldName);
		return result;
	}

	// TODO need info from ecore to determine operand's type to coerce.
	static String printSetInstr(String operand) throws Exception {

		String objType = typeStack.get(typeStack.size() - 2).getVal();
		String fieldName = objType + "." + operand;

		fieldName = EcoreReaderHelper.getAbstractStructuralFeatureName(fieldName, objType, operand, srcsfInfo,
				tarsfInfo, parentInfo);

		String result = "assert Seq#Length(stk) >= 2;\n";
		result += "assert $Unbox(Seq#Index(stk, Seq#Length(stk)-2)) != null;\n";
		result += "assert read($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), alloc);\n";

		if (tarsfInfo.containsKey(fieldName) && tarsfInfo.get(fieldName).startsWith("Seq;")) { // isCollection
			result += "havoc $newCol;\n";
			result += "assume dtype($newCol) == class._System.array;\n";
			result += "assume $newCol != null && read($tarHeap, $newCol, alloc);\n";
			result += String.format(
					"assume Seq#FromArray($tarHeap,$newCol) == Seq#Append(Seq#FromArray($tarHeap, read($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), %s)), Seq#FromArray($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1))));\n",
					fieldName);
			result += String.format(
					"$tarHeap := update($tarHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-2)), %s, $newCol);\n",
					fieldName);

		} else { // is normal field
			result += String.format("$tarHeap := update($tarHeap, " + "$Unbox(Seq#Index(stk, Seq#Length(stk)-2)),"
					+ "%s," + "$Unbox(Seq#Index(stk, Seq#Length(stk)-1)));\n", fieldName);
		}

		result += "assume $IsGoodHeap($tarHeap);\n";
		result += "stk := Seq#Take(stk, Seq#Length(stk)-2);\n";
		return result;

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

}
