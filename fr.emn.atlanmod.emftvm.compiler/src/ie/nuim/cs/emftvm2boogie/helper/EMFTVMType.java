package ie.nuim.cs.emftvm2boogie.helper;

public class EMFTVMType {
	TYPE type;
	String val;	// store val of String, dtype of ref
	
	public EMFTVMType(TYPE t){
		type = t;
		val = "";
	}
	
	public EMFTVMType(TYPE t, String v){
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
