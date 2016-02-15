package fr.emn.atlanmod.emftvm2boogie.helper;

public class ASMReaderHelper {

	
	public static String genVoidCall(String operand, int ln)
	{
		String res = "";
		switch(operand){
		case "NTransientLink;.addTargetElement(SJ):V": 
			res=String.format("call stk := %s(stk,%s,%s,%s);", 
					"NTransientLink#addTargetElement", 
					"$Unbox(Seq#Index(stk, Seq#Length(stk)-3))", 
					"$Unbox(Seq#Index(stk, Seq#Length(stk)-2))", 
					"$Unbox(Seq#Index(stk, Seq#Length(stk)-1))"); break;
		case "NTransientLink;.addSourceElement(SJ):V": 
			res= String.format("call stk := %s(stk,%s,%s,%s);", 
					"NTransientLink#addSourceElement", 
					"$Unbox(Seq#Index(stk, Seq#Length(stk)-3))", 
					"$Unbox(Seq#Index(stk, Seq#Length(stk)-2))", 
					"$Unbox(Seq#Index(stk, Seq#Length(stk)-1))"); break;
		case "NTransientLink;.setRule(MATL!Rule;):V": 
			res= String.format("call stk := %s(stk,%s,%s);", 
					"NTransientLink#setRule", 
					"$Unbox(Seq#Index(stk, Seq#Length(stk)-2))", 
					"$Unbox(Seq#Index(stk, Seq#Length(stk)-1))"); break;
		case "NTransientLinkSet;.addLink2(NTransientLink;B):V": 
			res="stk := Seq#Take(stk, Seq#Length(stk)-3);";
		
		default: break;
		
		}

		
		return res;
		
	}
	
	public static String genCallwithReturns(String operand, int ln, TypeStack stk) {
		String rtnType = operand.substring(operand.lastIndexOf(":")+1,operand.length());
		String res = "";
			
		switch(operand){
		case "NTransientLink;.getSourceElement(S):J": 
			res="NTransientLink#getSourceElement";
			res=String.format("call stk := %s(stk,%s,%s);", res,"$Unbox(Seq#Index(stk, Seq#Length(stk)-2))","$Unbox(Seq#Index(stk, Seq#Length(stk)-1))");
			break;
		case "NTransientLink;.getTargetElement(S):J": 
			res= "NTransientLink#getTargetElement";
			res=String.format("call stk := %s(stk,%s,%s);", res,"$Unbox(Seq#Index(stk, Seq#Length(stk)-2))","$Unbox(Seq#Index(stk, Seq#Length(stk)-1))");
			break;
		case "A.__resolve__(J):J": {	// copy from ASMSignatureHelper.typeInfer
			String tp = stk.get(stk.size()-1).getVal();
			String inferedType = "Unkown";
			switch(tp){
			case "EString": inferedType = "String";break;
			case "EInt": inferedType= "int";break;
			case "EBoolean": inferedType= "bool";break;
			default: inferedType = "ref";break;
			}
			res=String.format("call stk := ASM#Resolve(stk, $srcHeap, $Unbox(Seq#Index(stk, Seq#Length(stk)-1)): %s);", inferedType);break;
		}
		case "MMOF!Classifier;.allInstancesFrom(S):QJ":
			 res = String.format("call stk, obj#%d := LIB#AllInstanceFrom(stk, $srcHeap);", ln);break;
		case "J.=(J):J":
			res = String.format("call stk := OCLAny#Equal(stk,$Unbox(Seq#Index(stk, Seq#Length(stk)-2)): %s,$Unbox(Seq#Index(stk, Seq#Length(stk)-1)): %s);", "ref", "ref");
			break;
		case "J.and(J):J":
			res = "call stk := OCLAny#And(stk);";break;
		case "J.not():J":
			res = "call stk := OCLAny#Not(stk);";break;
		case "B.not():B":
			res = "call stk := OCL#Boolean#Not(stk);";break;
		case "J.oclIsTypeOf(J):J":
			res = "call stk := OCLAny#IsTypeof(stk);";break;
		case "J.oclIsUndefined():J":
			res = "call stk := OCLAny#IsUndefined(stk);";break;
		default: res= operand; break;
		
		}
				
				
			
		
			

			
			
		
		return res;
		
	}
}
