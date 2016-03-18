package fr.emn.atlanmod.emftvm2boogie.helper;

import java.util.List;

import org.eclipse.m2m.atl.emftvm.Instruction;

public class CodeBlockHelper {

	static public Instruction getInstrAt(List<Instruction> instrs, int ln) {

		int i = 0;
		for (Instruction instr : instrs) {
			if (i == ln) {
				return instr;
			}
			i++;
		}
		return null;
	}
	
}
