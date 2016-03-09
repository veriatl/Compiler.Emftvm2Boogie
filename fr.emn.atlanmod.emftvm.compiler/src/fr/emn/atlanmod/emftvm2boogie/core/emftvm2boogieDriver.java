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
//			System.out.print(printInstr(instr, localVars, ln, op.getInstructions()));
			System.out.println(instr);
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
