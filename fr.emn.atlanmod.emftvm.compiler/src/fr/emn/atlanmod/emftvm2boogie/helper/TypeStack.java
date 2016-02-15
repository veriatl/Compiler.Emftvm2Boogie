package fr.emn.atlanmod.emftvm2boogie.helper;

import java.util.Map;
import java.util.Stack;

import org.eclipse.m2m.atl.engine.vm.ASMInstruction;
import org.eclipse.m2m.atl.engine.vm.ASMInstructionWithOperand;




public class TypeStack{
	Stack<ASMType> stk;
	Map<String, String> localVars;
	Map<String, String> ins ;
	Map<String, String> outs ;
	Map<String, String> srcsf;
	Map<String, String> tarsf;
	Map<String, String> par;
	
	public static void main(String[] args) throws Exception {
		String s = "NTransientLinkSet;.getLinksByRule(S):MTransientLink";
		int n = ASMSignatureHelper.getNbArgs(s);
		//ASMType x = ASMSignatureHelper.getReturnASMType(s, stk);
		String r = ASMSignatureHelper.getReturnType(s);
		String sig = ASMSignatureHelper.getOpFullName(s);
		System.out.println(sig);
		
		
		
	}
	
	public TypeStack(Map<String, String> lvars, 
			Map<String, String> inputElements, 
			Map<String, String> outputElements,
			Map<String, String> ssf,
			Map<String, String> tsf,
			Map<String, String> par
			){
		this.stk = new Stack<ASMType>();
		this.localVars = lvars;
		this.ins = inputElements;
		this.outs = outputElements;
		this.srcsf = ssf;
		this.tarsf = tsf;
		this.par = par;
	}
	
	// push the type of instruction onto stack.
	public void act(ASMInstruction op){
		getASMType(op);
	}
	
	
	// get the type at index i of stack.
	public ASMType get(int i){
		return stk.get(i);
	}
	
	public ASMType top(){
		return stk.get(stk.size()-1);
	}
	
	
	public int size(){
		return stk.size();
	}
	
	private void getASMType(ASMInstruction instr){
		if(instr instanceof ASMInstructionWithOperand){	// case of instr with operand
			ASMInstructionWithOperand instro = (ASMInstructionWithOperand)instr;
			String operand = instro.getOperand();
			switch(instro.getMnemonic().toLowerCase()){
				case "push":
					stk.push(new ASMType(TYPE.STRING, operand));
					break;
				case "pushi":	
					stk.push(new ASMType(TYPE.INT));
					break;
				case "store":
					stk.pop();
					break;
				case "load":{ 
					String tp = localVars.get(operand);
					if(ins.containsKey(tp)){
						stk.push(new ASMType(TYPE.REF, ins.get(tp)));
					}else if(outs.containsKey(tp)){
						stk.push(new ASMType(TYPE.REF, outs.get(tp)));
					}else if(tp.equals("link")){
						stk.push(new ASMType(TYPE.REF, "Native$TransientLink"));
					}else{
						stk.push(new ASMType(TYPE.REF, tp+":Unknown"));
					}
						
					break;
				}
				case "if":	
					stk.pop();
					break;
				case "goto": // TODO
					break;
				case "call":{	
					int n = ASMSignatureHelper.getNbArgs(operand);
					ASMType rtnTp = ASMSignatureHelper.getReturnASMType
							(operand, stk, ins,outs,srcsf,tarsf);
					int i = 0;
					while(i<n){
						stk.pop();	// pop args.
						i++;
					}
					stk.pop(); // pop ctx
					stk.push(rtnTp);		
					break;
				}
				case "pcall":{
					int n = ASMSignatureHelper.getNbArgs(operand);
					int i = 0;
					while(i<n){
						stk.pop();	// pop args.
						i++;
					}
					stk.pop(); // pop ctx
					break;	
				}
				case "set":
					String v = stk.pop().getVal(); 
					String o = stk.pop().getVal(); 
					break;
				case "get":{
					String obj = stk.pop().getVal(); 
					String field = operand;
					String fieldId = obj+"."+field;
					
					fieldId = EcoreReaderHelper.getAbstractStructuralFeatureName(fieldId,obj,operand,srcsf,tarsf,par);
					
					
					if(srcsf.containsKey(fieldId)){
						stk.push(new ASMType(TYPE.ATTR, srcsf.get(fieldId)));
					}else if(tarsf.containsKey(fieldId)){
						stk.push(new ASMType(TYPE.ATTR, tarsf.get(fieldId)));
					}else{
						stk.push(new ASMType(TYPE.ATTR, fieldId+":Unknown"));
					}
					
					
					break;
				}
				default: 
					break;
			}
			
			
		}else{		// case of instr without operand
			switch(instr.getMnemonic().toLowerCase()){
				case "pusht":
					stk.push(new ASMType(TYPE.BOOL, "TRUE"));
					break;
				case "pushf":	
					stk.push(new ASMType(TYPE.BOOL, "FALSE"));
					break;
				case "pop":	
					stk.pop();
					break;	
				case "swap":	
					break;	
				case "dup":	{
					ASMType top = stk.pop();
					stk.push(top);
					stk.push(top);
					break;	
				}
				case "dup_x1":	{
					ASMType top = stk.pop();
					ASMType secondtop = stk.pop();
					stk.push(top);
					stk.push(secondtop);
					stk.push(top);
					break;
				}
				case "iterate":	{	
					ASMType col = stk.pop();
					String tp = col.getVal();
					String t = tp.substring(tp.indexOf(";")+1, tp.length());	
					stk.push(new ASMType(TYPE.REF, t));
					break;
				}
				case "enditerate":	
					break;
				case "new":{
					String mm = stk.pop().getVal();	// metamodel name
					String cl = stk.pop().getVal();	// classifier name 
					stk.push(new ASMType(TYPE.REF, mm+"$"+cl));
					break;
				}
				case "findme":{
					String mm = stk.pop().getVal();	// metamodel name
					String cl = stk.pop().getVal();	// classifier name 
					stk.push(new ASMType(TYPE.STRING, mm+"$"+cl));	
					break;
				}
				case "getasm":
					stk.push(new ASMType(TYPE.REF, "ASM"));
					break;
				default: 
					break;
			}
		}
	}
	
	

}
