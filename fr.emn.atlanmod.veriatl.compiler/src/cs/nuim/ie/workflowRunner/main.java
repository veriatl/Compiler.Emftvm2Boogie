package cs.nuim.ie.workflowRunner;




import ie.nuim.cs.emftvm2boogie.core.Driver;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.mwe.core.WorkflowRunner;
import org.eclipse.emf.mwe.core.monitor.NullProgressMonitor;

import cs.nuim.ie.worflowHelper.FileHelper;


public class main {

	public static String base = System.getProperty("user.dir");
	public static Map<String, String> dirs ;
	public static String projName;
	public static String boogiePath;

	
	public static void main(String[] args) throws Exception{
		
		Map<String, String> conf = FileHelper.myFileReader("veriATL.conf");
	    projName = conf.get("projname");	
	    boogiePath = conf.get("boogiePath");
	    
		dirs = FileHelper.myFileCreator(base, projName);	// (1) create project skeleton
		
		genMetamodels(projName);	//(2) uncomment this line to generate source and target metamodels. 
		genExecSem(projName);		//(2) uncomment this line to execution semantics from ATL transformation.
		genRuntime(projName);		//(2) uncomment this line to generate runtime behaviors from ASM implementation.
		genExternalConfigruation(projName, "_TranslationValidation");
	}
	
	// TODO: FINSH FILL IN THE PRELUDE PATH ETC.
	static void genExternalConfigruation(String proj, String nature) throws Exception{
		String outPath = base+"/"+proj+nature+".launch";
		String content = genExternalConfigruationHeader();
		
		content += "<stringAttribute key=\"org.eclipse.ui.externaltools.ATTR_LOCATION\" value=\""+boogiePath+"\"/>";
		content += "\n";	
		
		content += "<stringAttribute key=\"org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS\" value=\"";
		
		String prelude = "src/Prelude/";
		content += FileHelper.getFilesNames(base+"/", prelude, ".bpl", "&#10;");
		
		String auxPath = proj+dirs.get("rule")+"/";

		content += auxPath+"classifierTable.bpl"+"&#10;";
		content += auxPath+"constants.bpl"+"&#10;";
		
		String mmPath = proj+dirs.get("mm")+"/";
		content += FileHelper.getFilesNames(base+"/", mmPath, ".bpl", "&#10;");
		
		String execPath = proj+dirs.get("exec")+"/";
		content += FileHelper.getFilesNames(base+"/", execPath, ".bpl", "&#10;");
		
	
		if(nature.equals("_Correctness")){
			String driver = proj+dirs.get("correct")+"/";
			content += driver + "Driver.bpl&#10;";
		}
		
		content += "${resource_loc}";
		content += "\"/>";
		content += "\n";
		
		content += "<stringAttribute key=\"org.eclipse.ui.externaltools.ATTR_WORKING_DIRECTORY\" value=\""+base+"\"/>";
		content += "\n";
		
		content += genExternalConfigruationFooter();
		
		FileHelper.myFileWriter(outPath, content);
		
	}
	
	
	static String genExternalConfigruationHeader(){
		String header = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>";
		header += "\n";
		header += "<launchConfiguration type=\"org.eclipse.ui.externaltools.ProgramLaunchConfigurationType\">";
		header += "\n";
		return header;
	}
	
	static String genExternalConfigruationFooter(){
		String footer = "</launchConfiguration>";
		return footer;
	}
	
	static void genContract(String proj) throws Exception{
		String dirPath = base + "/" + proj + "/";
		String contract = dirPath + dirs.get("contract");
		String outPath = dirPath + dirs.get("correct");
		
		String workflow = base  + "/src/workflow/" + "Contract2Boogie.mwe";
		String srcPath = FileHelper.getFirstFile(contract);
		
		doRun(srcPath, outPath, workflow);
		
		String atl = dirPath + dirs.get("atl");
		String atlPath = FileHelper.getFirstFile(atl);
		workflow = base  + "/src/workflow/" + "Driver2Boogie.mwe";
		
		doRun(atlPath, outPath, workflow);
	}
	
	
	
	static void genRuntime(String proj) throws Exception{
		String dirPath = proj + "/";	

		String outPath = dirPath + dirs.get("rule");
		
		String emftvm = dirPath + dirs.get("emftvm")+"/";

		String moduleName = FileHelper.getFirstFileName(emftvm);
		
		
		String src = dirPath + dirs.get("srcmm");
		String tar = dirPath + dirs.get("tarmm");

		String srcId = FileHelper.getFirstFileName(src);
		String tarId = FileHelper.getFirstFileName(tar);
		
		String srcPath = src + "/"+ srcId+".ecore";
		String tarPath = tar + "/"+ tarId+".ecore";
		
		String genASM = outPath+"/";
		String genCl = outPath+"/";
		String genConst = outPath + "/";


		Driver.genClassifierTable(emftvm, moduleName, srcPath, srcId, tarPath, tarId, genCl);
		Driver.genConstant(emftvm, moduleName, srcPath, srcId, tarPath, tarId, genConst);
		Driver.genBoogie(emftvm, moduleName, srcPath, srcId, tarPath, tarId, genASM);
	}
	
	
	static void genExecSem(String proj) throws Exception{
		
		String dirPath = base + "/" + proj + "/";
		
		
		String atl = dirPath + dirs.get("atl");
		String outPath = dirPath + dirs.get("exec");	
		String workflow = base  + "/src/workflow/" + "atlApply2Boogie.mwe";	
			
		String atlPath = FileHelper.getFirstFile(atl);
		doRun(atlPath, outPath, workflow);
		
		workflow = base  + "/src/workflow/" + "atlMatch2Boogie.mwe";	
		doRun(atlPath, outPath, workflow);	
		
		workflow = base  + "/src/workflow/" + "surjective.mwe";	
		doRun(atlPath, outPath, workflow);	
		
		
	}
	
	static void genMetamodels(String proj) throws Exception{
		String dirPath = base + "/" + proj + "/";
		String src = dirPath + dirs.get("srcmm");
		String tar = dirPath + dirs.get("tarmm");
		String outPath = dirPath + dirs.get("mm");
		
		String workflow = base  + "/src/workflow/" + "mm2Boogie.mwe";
		
		String srcPath = FileHelper.getFirstFile(src);
		String tarPath = FileHelper.getFirstFile(tar);
		
		doRun(srcPath, outPath, workflow);
		doRun(tarPath, outPath, workflow);	
		 
	    workflow = base  + "/src/workflow/" + "aux2Boogie.mwe";
	    doRun(srcPath, outPath, workflow);
		doRun(tarPath, outPath, workflow);	
		
		workflow = base  + "/src/workflow/" + "validSrc2Boogie.mwe";
	    doRun(srcPath, outPath, workflow);
		
	}
	
	
	@SuppressWarnings("deprecation")
	static void doRun(String inputPath, String outPath, String workflow){
		File f = new File(inputPath);
		URI fileURI = URI.createFileURI(f.getAbsolutePath());

		Map<String, String> properties = new HashMap<String, String>();
		properties.put("model", fileURI.toString());
		properties.put("src-gen",outPath);
		Map slotContents = new HashMap();
		
		WorkflowRunner wr = new WorkflowRunner();
		
		wr.run(workflow, new NullProgressMonitor(), properties, slotContents);
	}
	
	
	

}
