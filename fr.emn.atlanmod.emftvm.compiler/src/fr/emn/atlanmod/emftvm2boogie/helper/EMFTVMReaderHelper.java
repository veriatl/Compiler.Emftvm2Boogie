package fr.emn.atlanmod.emftvm2boogie.helper;

public class EMFTVMReaderHelper {

	
	public static String genCall(String operand, int ln, TypeStack stk, boolean isStatic) {
		String rtnType = operand.substring(operand.lastIndexOf(":")+1,operand.length());
		String res = "";
		
		if(!isStatic){//invoke
			switch(operand){
				case "resolve": {	// copy from ASMSignatureHelper.typeInfer
					String tp = stk.get(stk.size()-1).getVal();
					String inferedType = "Unkown";
					switch(tp){
					case "EString": inferedType = "String";break;
					case "EInt": inferedType= "int";break;
					case "EBoolean": inferedType= "bool";break;
					default: inferedType = "ref";break;
					}
					res=String.format("call stk := EMFTVM#Resolve(stk, $srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)): %s);", inferedType);break;
				}
				case "=":
					res = String.format("call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): %s,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): %s);", "ref", "ref");
					break;
				case "=~":
					res = String.format("call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): %s,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): %s);", "ref", "ref");
					break;
				case "+":
					res = String.format("call stk := OCL#Integer#ADD(stk);");
					break;
				case "and":
					res = "call stk := OCLAny#And(stk);";break;
				case "not":
					res = "call stk := OCLAny#Not(stk);";break;
				case "oclIsTypeOf":
					res = "call stk := OCLAny#IsTypeof(stk);";break;
				case "oclIsKindOf":
					res = "call stk := OCLAny#IsKindof(stk);";break;
				case "oclIsUndefined":
					res = "call stk := OCLAny#IsUndefined(stk);";break;
				default: res= operand; break;
			
			}
		}else{	// invoke_static
			
		}
	
		
		return res;
		
	}
}
