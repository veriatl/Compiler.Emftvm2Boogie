package fr.emn.atlanmod.emftvm2boogie.helper;

public class ASMType {
	TYPE type;
	String val;	// store val of String, dtype of ref
	
	public ASMType(TYPE t){
		type = t;
		val = "";
	}
	
	public ASMType(TYPE t, String v){
		type = t;
		val = v;
	}
	
	
	public String getVal(){
		return val;
	}
	
	public String toString(){
		return type+": "+val;
	}
}
