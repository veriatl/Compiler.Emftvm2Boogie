package cs.nuim.ie.worflowHelper;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;

public class FileHelper {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	
	
	public static void myFileWriter(String pName, String content) throws IOException{
		File file = new File(pName); 
		FileUtils.writeStringToFile(file, content, false);
	}
	
	public static Map<String, String> myFileCreator(String base, String name) throws IOException{
		Map<String, String> pthMap = new HashMap<String, String>();
		
		
		String pName = base+"/"+name;
		File file = new File(pName); 
		FileUtils.forceMkdir(file);
		
	
		pthMap.put("mm","/Metamodels");
		pthMap.put("rule","/SimpleGT_Rule_Encoding");
		pthMap.put("exec","/ExecutionSemantics");
		pthMap.put("simplegt_src","/Source/SimpleGTSRC");
		pthMap.put("srcmm","/Source/SRCMM");
		pthMap.put("emftvm","/Source/EMFTVM");


		
		for(String folder : pthMap.values()){
			String fName = pName+"/"+folder;
			file = new File(fName); 
			FileUtils.forceMkdir(file);
			
		}
		
		return pthMap;
	}
	
	public static Map<String, String> myFileReader(String name) throws IOException{
		Map<String, String> conf = new HashMap<String, String>();
		List<String> lines = FileUtils.readLines(new File(name));
		
		for(String line : lines){
			String[] config = line.split(":");
			conf.put(config[0], config[1]);
		}
		
		return conf;
	}
	
	
	public static String getFirstFile(String name) throws Exception{
		File file = new File(name);

        if (file.isDirectory()) {
            for(File fl : file.listFiles()){
            	return fl.getAbsolutePath();
            }
        }
        throw new Exception("no file found");
	}
	
	public static String getFirstFileName(String name) throws Exception{
		File file = new File(name);

        if (file.isDirectory()) {
            for(File fl : file.listFiles()){
            	return fl.getName().substring(0, fl.getName().lastIndexOf("."));
            }
        }
        throw new Exception("no file found");
	}
	
	public static String getFilesNames(String Base, String subPath, String ext, String delimiter) throws Exception{
		
		String Path = Base + subPath;
		
		File file = new File(Path);

		
		String res = "";
		
        if (file.isDirectory()) {
            for(File fl : file.listFiles()){
            	String flExt = fl.getName().substring(fl.getName().lastIndexOf("."));
            	
            	if(flExt.equals(ext)){
            		res += subPath+fl.getName();
            		res += delimiter;
            	}
            }
        }
		
        return res;
	}
	
	
}
