package ie.nuim.cs.emftvm2boogie.helper;

import java.util.Map;
import java.util.Stack;

import org.eclipse.m2m.atl.emftvm.Instruction;
import org.eclipse.m2m.atl.emftvm.impl.AndImpl;
import org.eclipse.m2m.atl.emftvm.impl.BranchInstructionImpl;
import org.eclipse.m2m.atl.emftvm.impl.CodeBlockInstructionImpl;
import org.eclipse.m2m.atl.emftvm.impl.FieldInstructionImpl;
import org.eclipse.m2m.atl.emftvm.impl.FindtypeImpl;
import org.eclipse.m2m.atl.emftvm.impl.GetImpl;
import org.eclipse.m2m.atl.emftvm.impl.GetcbImpl;
import org.eclipse.m2m.atl.emftvm.impl.InvokeImpl;
import org.eclipse.m2m.atl.emftvm.impl.InvokeInstructionImpl;
import org.eclipse.m2m.atl.emftvm.impl.LoadImpl;
import org.eclipse.m2m.atl.emftvm.impl.LocalVariableInstructionImpl;
import org.eclipse.m2m.atl.emftvm.impl.NewImpl;
import org.eclipse.m2m.atl.emftvm.impl.PushImpl;









public class TypeStack{
	Stack<EMFTVMType> stk;
	Map<String, String> localVars;
	Map<String, String> ins ;
	Map<String, String> outs ;
	Map<String, String> srcsf;
	Map<String, String> tarsf;
	Map<String, String> par;
	

	
	public TypeStack(Map<String, String> lvars, 
			Map<String, String> inputElements, 
			Map<String, String> outputElements,
			Map<String, String> ssf,
			Map<String, String> tsf,
			Map<String, String> par
			){
		this.stk = new Stack<EMFTVMType>();
		this.localVars = lvars;
		this.ins = inputElements;
		this.outs = outputElements;
		this.srcsf = ssf;
		this.tarsf = tsf;
		this.par = par;
	}
	
	// push the type of instruction onto stack.
	public void act(Instruction op){
		getEMFTVMType(op);
	}
	
	
	// get the type at index i of stack.
	public EMFTVMType get(int i){
		return stk.get(i);
	}
	
	public EMFTVMType top(){
		return stk.get(stk.size()-1);
	}
	
	
	public int size(){
		return stk.size();
	}
	
	private void getEMFTVMType(Instruction instr){
		if (instr instanceof FieldInstructionImpl) {
			FieldInstructionImpl instro = (FieldInstructionImpl) instr;

			switch (instro.getOpcode()) {
			case ADD:
			{
				stk.pop(); 
				stk.pop(); 
				break;
			}
			case GET:
			{
				GetImpl tempInstr = (GetImpl) instr;
				String operand = tempInstr.getFieldname();
				
				String obj = stk.pop().getVal(); 
				String field = operand;
				String fieldId = obj+"."+field;
				
				fieldId = EcoreReaderHelper.getAbstractStructuralFeatureName(fieldId,obj,operand,srcsf,tarsf,par);
				
				
				if(srcsf.containsKey(fieldId)){
					stk.push(new EMFTVMType(TYPE.ATTR, srcsf.get(fieldId)));
				}else if(tarsf.containsKey(fieldId)){
					stk.push(new EMFTVMType(TYPE.ATTR, tarsf.get(fieldId)));
				}else{
					stk.push(new EMFTVMType(TYPE.ATTR, fieldId+":Unknown"));
				}
				break;
			}
			case GET_STATIC:
			{
				GetImpl tempInstr = (GetImpl) instr;
				String operand = tempInstr.getFieldname();
				
				String obj = stk.pop().getVal(); 
				String field = operand;
				String fieldId = obj+"."+field;
				
				fieldId = EcoreReaderHelper.getAbstractStructuralFeatureName(fieldId,obj,operand,srcsf,tarsf,par);
				
				
				if(srcsf.containsKey(fieldId)){
					stk.push(new EMFTVMType(TYPE.ATTR, srcsf.get(fieldId)));
				}else if(tarsf.containsKey(fieldId)){
					stk.push(new EMFTVMType(TYPE.ATTR, tarsf.get(fieldId)));
				}else{
					stk.push(new EMFTVMType(TYPE.ATTR, fieldId+":Unknown"));
				}
				break;
			}
			case INSERT:
			{
				stk.pop(); 
				stk.pop(); 
				stk.pop(); 
				break;
			}
			case REMOVE:
			{
				stk.pop(); 
				stk.pop(); 
				break;
			}
			case SET:
				stk.pop(); 
				stk.pop(); 
				break;
			case SET_STATIC:
			{
				stk.pop(); 
				stk.pop(); 
				break;
			}
			default:
				break;
			}
		}else if(instr instanceof LocalVariableInstructionImpl){
			switch (instr.getOpcode()) {
			case STORE:
			{	
				stk.pop();
				break;
			}
			case LOAD:
			{	
				LoadImpl tempInstr = (LoadImpl) instr;
				String type = tempInstr.getLocalVariable().getTypeModel()+"$"+tempInstr.getLocalVariable().getType();
				
				stk.push(new EMFTVMType(TYPE.REF, type));
				break;
			}
			default:
			{	
				break;
			}
			}
		}else if(instr instanceof BranchInstructionImpl){
			switch (instr.getOpcode()) {
			case ENDITERATE:
			{
				break;
			}
			case GOTO:
			{
				break;
			}
			case IF:
			{	
				stk.pop();
				break;
			}
			case IFN: 
			{
				stk.pop();
				break;
			}
			case ITERATE:
			{	
				EMFTVMType col = stk.pop();
				String tp = col.getVal();
				String t = tp.substring(tp.indexOf(";")+1, tp.length());	
				stk.push(new EMFTVMType(TYPE.REF, t));
				break;
			}
			default:
				break;
			}
		}else if(instr instanceof CodeBlockInstructionImpl){
			switch (instr.getOpcode()) {
			case AND:
			{
				stk.pop();
				stk.push(new EMFTVMType(TYPE.BOOL, "???")); 
				
				break;
			}
			case GETCB:{
				GetcbImpl tInstr = (GetcbImpl)instr;
				stk.push(new EMFTVMType(TYPE.CB, tInstr.getCodeBlock().toString()));
				break;
			}
			case IMPLIES:
			{
				stk.pop();
				stk.push(new EMFTVMType(TYPE.BOOL, "???")); 
				break;
			}
			case INVOKE_CB:
			{
				//TODO
				break;
			}
			case OR:
			{
				stk.pop();
				stk.push(new EMFTVMType(TYPE.BOOL, "???")); 
				break;
			}
			default:
				break;
			}
		}else if(instr instanceof InvokeInstructionImpl){
			switch (instr.getOpcode()) {
			case INVOKE_CB_S:
			{
				//TODO
				break;
			}
			case INVOKE:
			{
				InvokeImpl invoke = (InvokeImpl) instr;
				String operand = invoke.getOpname();
				int n = invoke.getArgcount();
				
				EMFTVMType rtnTp = EMFTVMSignatureHelper.getReturnEMFTVMType(operand, stk, ins,outs,srcsf,tarsf);
				int i = 0;
				while(i<n){
					stk.pop();	// pop args.
					i++;
				}
				stk.pop(); // pop ctx
				stk.push(rtnTp);
				
				break;
			}
			case INVOKE_STATIC:
			{
				InvokeImpl invoke = (InvokeImpl) instr;
				String operand = invoke.getOpname();
				int n = invoke.getArgcount();
				
				EMFTVMType rtnTp = EMFTVMSignatureHelper.getReturnEMFTVMType(operand, stk, ins,outs,srcsf,tarsf);
				int i = 0;
				while(i<n){
					stk.pop();	// pop args.
					i++;
				}
				stk.pop(); // pop ctx
				stk.push(rtnTp);
				break;
			}
			default:
				break;
			}
		}else{
			switch (instr.getOpcode()) {
			case ALLINST:
			{
				String cl = stk.pop().getVal();
				stk.push(new EMFTVMType(TYPE.SEQ, cl)); 
				break;
			}
			case ALLINST_IN:
			{
				String hp = stk.pop().getVal();
				String cl = stk.pop().getVal();
				stk.push(new EMFTVMType(TYPE.SEQ, cl));
				break;
			}
			case DELETE :
			{
				stk.pop();
				break;
			}
			case DUP:
			{	
				EMFTVMType top = stk.peek();
				stk.push(top);
				break;
			}
			case DUP_X1:
			{	
				EMFTVMType top = stk.pop();
				EMFTVMType secondtop = stk.pop();
				stk.push(top);
				stk.push(secondtop);
				stk.push(top);
				break;
			}
			case FINDTYPE:
			{	
				FindtypeImpl tempInstr = (FindtypeImpl) instr;	
				String mm = tempInstr.getModelname();
				String cl = tempInstr.getTypename();
				stk.push(new EMFTVMType(TYPE.STRING, mm+"$"+cl));	
				break;
			}
			case FINDTYPE_S:
			{	
				String mm = stk.pop().getVal();	// metamodel name
				String cl = stk.pop().getVal();	// classifier name 
				stk.push(new EMFTVMType(TYPE.STRING, mm+"$"+cl));	
				break;
			}
			case GETENV:
			{	
				stk.push(new EMFTVMType(TYPE.REF, "ASM"));
				break;
			}
			case GETENVTYPE:
			{
				stk.push(new EMFTVMType(TYPE.STRING, "Native$Asm"));	//todo
				break;
			}
			case IFTE:
			{
				stk.pop();
				break;
			}
			case ISNULL:
			{
				stk.push(new EMFTVMType(TYPE.BOOL, "???")); 
				break;
			}
			case NEW:
			{
				NewImpl tempInstr = (NewImpl) instr;	
				String mm = tempInstr.getModelname();
				String cl = stk.pop().getVal();	// classifier name 
				stk.push(new EMFTVMType(TYPE.REF, mm+"$"+cl));
				break;
			}
			case NEW_S:
			{
				String mm = stk.pop().getVal();	// metamodel name
				String cl = stk.pop().getVal();	// classifier name 
				stk.push(new EMFTVMType(TYPE.REF, mm+"$"+cl));
				break;
			}
			case NOT:
			{
				stk.push(new EMFTVMType(TYPE.BOOL, "???"));
				break;
			}
			case POP:
			{
				stk.pop();
				break;
			}
			case PUSH:
			{
				PushImpl tempInstr = (PushImpl) instr;	
				stk.push(new EMFTVMType(TYPE.STRING, tempInstr.getValue().toString()));
				break;
			}
			case PUSHT:
			{
				stk.push(new EMFTVMType(TYPE.BOOL, "TRUE"));
				break;
			}
			case PUSHF:
			{
				stk.push(new EMFTVMType(TYPE.BOOL, "FALSE"));
				break;
			}
			case RETURN:
			{
				break;
			}
			case SWAP:{
				EMFTVMType top = stk.pop();
				EMFTVMType secondtop = stk.pop();
				stk.push(top);
				stk.push(secondtop);
				break;
			}
			case SWAP_X1:
			{
				EMFTVMType top = stk.pop();
				EMFTVMType secondtop = stk.pop();
				EMFTVMType thirdtop = stk.pop();

				
				stk.push(secondtop);
				stk.push(top);
				stk.push(thirdtop);
				break;
			}
			case XOR:
			{	
				stk.push(new EMFTVMType(TYPE.BOOL, "???")); 
				break;
			}
			default:
				break;
			}	
		}
		
	}
	
	

}
