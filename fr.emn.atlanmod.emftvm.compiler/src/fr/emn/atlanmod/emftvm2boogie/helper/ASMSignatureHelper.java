package fr.emn.atlanmod.emftvm2boogie.helper;

import java.util.Map;
import java.util.Stack;
import java.util.regex.Pattern;

public class ASMSignatureHelper {
	private static Pattern pattern1 = Pattern.compile("^.*\\("); //$NON-NLS-1$
	private static Pattern simple = Pattern.compile("^J|I|B|S|D|A|(M|N)[^;]*;|L"); //$NON-NLS-1$
	private static Pattern pattern2 = Pattern.compile("^(Q|G|C|E|O).*"); //$NON-NLS-1$

	
	private static String typeInfer(String op, Stack<ASMType> stk,
			Map<String, String> ins,Map<String, String> outs, 
			Map<String, String> srcsf, Map<String, String> tarsf){
		String opName = getOpName(op);
		String res;
		switch(opName){
		case "getSourceElement": res = ins.get(stk.get(stk.size()-1).getVal()); break;
		case "getTargetElement": res = outs.get(stk.get(stk.size()-1).getVal()); break;
		case "allInstancesFrom": res = "Seq;"+stk.get(stk.size()-2).getVal(); break;
		case "__resolve__": { // being copied by ASMReaderHelper.genCallwithReturns
			String tp = stk.get(stk.size()-1).getVal();
			switch(tp){
			case "EString": res = "String";break;
			case "EInt": res= "int";break;
			case "EBool": res= "bool";break;
			default: res = "ref";break;
			}
			break;
		}
		default: res="Unkown"; break;
		}
		return res;
	}
	
	
	
	public static ASMType getReturnASMType(String s, Stack<ASMType> stk,
			Map<String, String> ins,Map<String, String> outs, 
			Map<String, String> srcsf, Map<String, String> tarsf){
		String r = getReturnType(s);	// return type;
		String id = r.substring(0,1);	// first letter, id the type.
		
		switch(id){
			case "S": return new ASMType(TYPE.STRING);
			case "I": return new ASMType(TYPE.INT);
			case "B": return new ASMType(TYPE.BOOL);
			case "J": {	//TODO
				String tp = typeInfer(s, stk, ins,outs,srcsf,tarsf);
				return new ASMType(TYPE.REF, tp);
			}
			case "M": 
			case "N": {
				String rest = r.substring(1, r.length());
				return new ASMType(TYPE.REF, rest);
			}
			case "Q": {	
				String tp = typeInfer(s, stk, ins,outs,srcsf,tarsf);
				return new ASMType(TYPE.SEQ, tp);
			}
			default: return new ASMType(TYPE.UNKNOWN);
		} 
	}
	
	public static String getReturnType(String s) {
		return s.substring(s.lastIndexOf(":")+1, s.length());
	}
	
	public static int getNbArgs(String s) {
		int ret = 0;

		s = pattern1.matcher(s).replaceFirst(""); //$NON-NLS-1$
		while (!s.startsWith(")") && s.length() > 0) { //$NON-NLS-1$
			ret++;
			s = removeFirst(s);
		}

		return ret;
	}

	public static String removeFirst(String s) {
		if (s.startsWith("T")) { //$NON-NLS-1$
			s = s.substring(1);
			while (!s.startsWith(";")) { //$NON-NLS-1$
				s = removeFirst(s);
			}
			s = s.substring(1);
		} else if (pattern2.matcher(s).matches()) {
			s = removeFirst(s.substring(1));
		} else {
			s = simple.matcher(s).replaceFirst(""); //$NON-NLS-1$
		}

		return s;
	}

	public static String getOpFullName(String s) {
		return s.substring(0, s.indexOf("(")); //$NON-NLS-1$ //$NON-NLS-2$
	}
	
	public static String getOpName(String s) {
		return s.substring(s.indexOf(".") + 1, s.indexOf("(")); //$NON-NLS-1$ //$NON-NLS-2$
	}
}
