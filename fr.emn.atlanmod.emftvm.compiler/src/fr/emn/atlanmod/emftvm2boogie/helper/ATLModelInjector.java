package fr.emn.atlanmod.emftvm2boogie.helper;


import java.io.FileInputStream;
import java.io.InputStream;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.m2m.atl.core.IExtractor;
import org.eclipse.m2m.atl.core.IInjector;
import org.eclipse.m2m.atl.core.IModel;
import org.eclipse.m2m.atl.core.IReferenceModel;
import org.eclipse.m2m.atl.core.ModelFactory;
import org.eclipse.m2m.atl.core.emf.EMFExtractor;
import org.eclipse.m2m.atl.core.emf.EMFInjector;
import org.eclipse.m2m.atl.core.emf.EMFModelFactory;
import org.eclipse.m2m.atl.emftvm.EmftvmFactory;
import org.eclipse.m2m.atl.emftvm.ExecEnv;
import org.eclipse.m2m.atl.emftvm.Metamodel;
import org.eclipse.m2m.atl.emftvm.impl.resource.EMFTVMResourceFactoryImpl;
import org.eclipse.m2m.atl.emftvm.util.DefaultModuleResolver;
import org.eclipse.m2m.atl.engine.parser.AtlParser;

// TCS

public class ATLModelInjector {


	


	public static ExecEnv moduleLoader(String ATLFilePath, String ATLModuleName, 
			String sourceMMPath, String targetMMPath, String sourceId, String targetId)
	{
		ExecEnv env = EmftvmFactory.eINSTANCE.createExecEnv();
		ResourceSet rs = new ResourceSetImpl();
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("xmi", new XMIResourceFactoryImpl());
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("emftvm", new EMFTVMResourceFactoryImpl());
		
		
		
		
		if(sourceId!=""){
			// Load metamodels
			Metamodel metaModel = EmftvmFactory.eINSTANCE.createMetamodel();
			metaModel.setResource(rs.getResource(URI.createURI(sourceMMPath), true));
			env.registerMetaModel(sourceId, metaModel);

			Resource r = rs.getResource(URI.createURI(sourceMMPath), true);
			EObject eObject = r.getContents().get(0);
			if (eObject instanceof EPackage) {
			    EPackage p = (EPackage)eObject;
			    rs.getPackageRegistry().put(p.getNsURI(), p);
			}
		}
	
		if(targetId!=""){
			// Load metamodels
			Metamodel metaModel = EmftvmFactory.eINSTANCE.createMetamodel();
			metaModel.setResource(rs.getResource(URI.createURI(targetMMPath), true));
			env.registerMetaModel(targetId, metaModel);

			Resource r = rs.getResource(URI.createURI(targetMMPath), true);
			EObject eObject = r.getContents().get(0);
			if (eObject instanceof EPackage) {
			    EPackage p = (EPackage)eObject;
			    rs.getPackageRegistry().put(p.getNsURI(), p);
			}
		}
		
		// load emftvm module
		DefaultModuleResolver mr = new DefaultModuleResolver(URI.createFileURI(ATLFilePath).toString(), rs);
		env.loadModule(mr, ATLModuleName);
		
		return env;
		
	}
	
	
	public static void genATLModel(String Path, String moduleName) throws Exception{
		String ATLPath = Path+moduleName;
		String storePath = Path+moduleName+".xmi";
		genATLModeltoXMI(ATLPath, storePath);
		System.out.println("finished");
		//TODO read xmi file
		
	}
	
	public static void genATLModeltoXMI(String ATLPath, String storePath) throws Exception{
		InputStream input = new FileInputStream(ATLPath);
		AtlParser atlParser = AtlParser.getDefault();
		IModel m = atlParser.parseToModel(input);
		
		ModelFactory modelFactory = new EMFModelFactory();
		IInjector injector = new EMFInjector();
		IExtractor extractor = new EMFExtractor();
		
		IReferenceModel atlMeta = modelFactory.newReferenceModel();
		injector.inject(atlMeta, "src/metamodels/ATL.ecore");
		
		extractor.extract(m, storePath);
	}
	
	
	public static void main(String[] args) throws Exception{
		genATLModel("src/emftvm/", "PacmanContract.atl");
	}

}
