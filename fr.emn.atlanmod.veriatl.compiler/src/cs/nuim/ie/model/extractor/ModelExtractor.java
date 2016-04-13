package cs.nuim.ie.model.extractor;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.eclipse.m2m.atl.core.IExtractor;
import org.eclipse.m2m.atl.core.IInjector;
import org.eclipse.m2m.atl.core.IModel;
import org.eclipse.m2m.atl.core.IReferenceModel;
import org.eclipse.m2m.atl.core.ModelFactory;
import org.eclipse.m2m.atl.core.emf.EMFExtractor;
import org.eclipse.m2m.atl.core.emf.EMFInjector;
import org.eclipse.m2m.atl.core.emf.EMFModelFactory;
import org.eclipse.m2m.atl.engine.parser.AtlParser;

public class ModelExtractor {

	public static String atlEcore = "src/metamodel/ATL.ecore";
	
	public static void XmiHeaderInjector(String xmi, String pth) throws Exception{
		List<String> lines = FileUtils.readLines(new File(xmi));

		File out = new File(pth);
		String header = "<xmi:XMI xmi:version=\"2.0\" xmlns:xmi=\"http://www.omg.org/XMI\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:atl=\"http://www.eclipse.org/gmt/2005/ATL\" xmlns:ocl=\"http://www.eclipse.org/gmt/2005/OCL\"";
		
		FileUtils.deleteQuietly(out);
		
		for(String line : lines){
			 
			if(line.contains(header)){
				header += " xsi:schemaLocation=\"http://www.eclipse.org/gmt/2005/OCL ../../../src/metamodel/ATL.ecore#/1 http://www.eclipse.org/gmt/2005/ATL ../../../src/metamodel/ATL.ecore#/0\">";
				FileUtils.writeStringToFile(out, header+"\n", true);
			}else{
				FileUtils.writeStringToFile(out, line+"\n", true);
				
			}
		}
		
		
	}
	
	public static void genATLModel(String Path, String moduleName, String output) throws Exception{
		String ATLPath = Path+moduleName;
		String storePath = output+moduleName+".xmi.org";
		String finalStorePath = output+"/final/"+moduleName+".xmi";
		System.out.println(finalStorePath);
		genATLModeltoXMI(ATLPath, storePath);
		
		
		XmiHeaderInjector(storePath,finalStorePath);
		
		System.out.println("Finished");
	}
	
	public static void genATLModeltoXMI(String ATLPath, String storePath) throws Exception{
		InputStream input = new FileInputStream(ATLPath);
		AtlParser atlParser = AtlParser.getDefault();
		IModel m = atlParser.parseToModel(input);
		
		ModelFactory modelFactory = new EMFModelFactory();
		IInjector injector = new EMFInjector();
		IExtractor extractor = new EMFExtractor();
		
		IReferenceModel atlMeta = modelFactory.newReferenceModel();
		injector.inject(atlMeta, atlEcore);
		
		extractor.extract(m, storePath);
	}
	
	

	
	
	public static void main(String[] args) throws Exception{
		genATLModel("ER2REL_EXP/Source/ATLSRC/", "er2rel.atl", "ER2REL_EXP/Source/ATL/");
	}

}
