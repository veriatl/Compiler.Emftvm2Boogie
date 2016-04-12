package ie.nuim.cs.emftvm2boogie.helper;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;
import org.eclipse.m2m.atl.emftvm.EmftvmFactory;
import org.eclipse.m2m.atl.emftvm.Metamodel;

public class EcoreReaderHelper {

	
	public static EPackage readEcore(String metamodelPath) throws Exception{
		// Load metamodels
		ResourceSet rs = new ResourceSetImpl();
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
	
		Metamodel metaModel = EmftvmFactory.eINSTANCE.createMetamodel();
		metaModel.setResource(rs.getResource(URI.createURI(metamodelPath), true));
		
		Resource r = rs.getResource(URI.createURI(metamodelPath), true);
		EObject eObject = r.getContents().get(0);
		if (eObject instanceof EPackage) {
		    EPackage p = (EPackage)eObject;
		    return p;
		}
		
		throw new Exception("reading metamodel fails hard! abort...");
		
	}
	
	// read eattriute info as maps.
	public static Map<String, String> readEinfo(EPackage mm) throws Exception{
		String mmName = mm.getName();
		Map<String, String> info = new HashMap<String, String>();
		
		
		for(EClassifier cl : mm.getEClassifiers()){
			if(cl instanceof EClass){
				EClass clazz = (EClass)cl;
				for(EAttribute attr : clazz.getEAttributes()){
					
					String attrId = attr.getName();
					String attrDtype = attr.getEAttributeType().getName();
					
					if(info.containsKey(attrId)){
						if(info.get(attrId)!=attrDtype){
							throw new Exception(
								String.format("mismatched datatype for attribute %s: %s, %s", 
										attrId, attrDtype, info.get(attrId)));
						}
					}
					
					info.put(attrId, attrDtype);
				}
				

			}
			
		}
	
		return info;
		
	}
	
	
	public static Map<String, String> readParantInfo(EPackage mm) throws Exception{
		String mmName = mm.getName();
		Map<String, String> info = new HashMap<String, String>();
		
		
		for(EClassifier cl : mm.getEClassifiers()){
			String clName = String.format("%s$%s",mmName,cl.getName());

			if(cl instanceof EClass){
				EClass clazz = (EClass)cl;
				
				for(EClass sp : clazz.getESuperTypes()){
					String spName = String.format("%s$%s",mmName,sp.getName());
					info.put(clName, spName);
				}			
			}
			
		}
	
		return info;
	}
	
	public static String getAbstractStructuralFeatureName(
			String sf, String objType, String sfName,
			Map<String, String> srcInfo, Map<String, String> tarInfo,
			Map<String, String> parInfo
			){
		if((!srcInfo.containsKey(sf) || !tarInfo.containsKey(sf))&& parInfo.containsKey(objType)){
			// src and tar Info dont have sf, indicate sf is possible an abstract sf.
			return String.format("%s.%s",parInfo.get(objType),sfName);
		}else{
			return sf;
		}
	}
	
	
	// read metamodel info as maps.
		public static Map<String, String> readEinfoAll(EPackage mm) throws Exception{
			String mmName = mm.getName();
			Map<String, String> info = new HashMap<String, String>();
			
			
			for(EClassifier cl : mm.getEClassifiers()){
				String clName = cl.getName();
				if(cl instanceof EClass){
					EClass clazz = (EClass)cl;
					
					for(EAttribute attr : clazz.getEAttributes()){
						
						String attrId = mmName+"$"+clName+"."+attr.getName();
						String attrDtype = attr.getEAttributeType().getName();
						
						if(info.containsKey(attrId)){
							if(!info.get(attrId).equals(attrDtype)){
								throw new Exception(
									String.format("mismatched datatype for attribute %s: %s, %s", 
											attrId, attrDtype, info.get(attrId)));
							}
						}
						
						info.put(attrId, attrDtype);
					}
					
					for(EReference ref : clazz.getEReferences()){
						
						String refId = mmName+"$"+clName+"."+ref.getName();
						String refDtype;
						if(ref.getUpperBound() == -1 || ref.getUpperBound() > 1){
							refDtype = "Seq;"+mmName+"$"+ref.getEReferenceType().getName();
						}else{
							refDtype = mmName+"$"+ref.getEReferenceType().getName();
						}
						
						if(info.containsKey(refId)){
							if(!info.get(refId).equals(refDtype)){
								throw new Exception(
									String.format("mismatched datatype for reference %s: %s, %s", 
											refId, refDtype, info.get(refId)));
							}
						}
						
						info.put(refId, refDtype);
					}
				}
				
			}
		
			return info;
			
		}
	
	public static void main(String[] args) throws Exception{
		
		EPackage mm = readEcore("src/metamodels/HSM.ecore");
		Map<String, String> map = readEinfoAll(mm);
		System.out.println(map);
	}
	
}