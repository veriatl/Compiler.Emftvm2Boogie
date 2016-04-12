package ie.nuim.cs.emftvm2boogie.helper;

import java.util.Map;
import java.util.Stack;
import java.util.regex.Pattern;

public class EMFTVMSignatureHelper {
	private static Pattern pattern1 = Pattern.compile("^.*\\("); //$NON-NLS-1$
	private static Pattern simple = Pattern.compile("^J|I|B|S|D|A|(M|N)[^;]*;|L"); //$NON-NLS-1$
	private static Pattern pattern2 = Pattern.compile("^(Q|G|C|E|O).*"); //$NON-NLS-1$

	
	public static EMFTVMType getReturnEMFTVMType(String opName, Stack<EMFTVMType> stk,
			Map<String, String> ins,Map<String, String> outs, 
			Map<String, String> srcsf, Map<String, String> tarsf){
		EMFTVMType res = new EMFTVMType(TYPE.REF, "Unknown");
		String resTp;
		switch(opName){
			case "resolve": { 
				String top = stk.get(stk.size()-1).getVal();
				switch(top){
				case "EString": resTp = "String";break;
				case "EInt": resTp= "int";break;
				case "EBool": resTp= "bool";break;
				default: resTp = "ref";break;
				}
				res = new EMFTVMType(TYPE.REF, resTp);
				break;
			}
			default:
		}
		return res;
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
