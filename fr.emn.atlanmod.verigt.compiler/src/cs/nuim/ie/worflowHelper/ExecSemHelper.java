package cs.nuim.ie.worflowHelper;

import com.google.common.base.Charsets;
import com.google.common.base.Objects;
import com.google.common.io.Files;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipselabs.simplegt.InPattern;
import org.eclipselabs.simplegt.InputBinding;
import org.eclipselabs.simplegt.InputElement;
import org.eclipselabs.simplegt.NacPattern;
import org.eclipselabs.simplegt.OutPattern;
import org.eclipselabs.simplegt.OutputBinding;
import org.eclipselabs.simplegt.OutputElement;
import org.eclipselabs.simplegt.Rule;
import org.eclipselabs.simplegt.SimplegtPackage;
import org.eclipselabs.simplegt.resource.simplegt.mopp.SimplegtResourceFactory;
import org.eclipselabs.simpleocl.AddOpCallExp;
import org.eclipselabs.simpleocl.IntegerExp;
import org.eclipselabs.simpleocl.Module;
import org.eclipselabs.simpleocl.ModuleElement;
import org.eclipselabs.simpleocl.NavigationOrAttributeCall;
import org.eclipselabs.simpleocl.OclExpression;
import org.eclipselabs.simpleocl.OclModel;
import org.eclipselabs.simpleocl.OclModelElement;
import org.eclipselabs.simpleocl.OclType;
import org.eclipselabs.simpleocl.PropertyCall;
import org.eclipselabs.simpleocl.PropertyCallExp;
import org.eclipselabs.simpleocl.SimpleoclPackage;
import org.eclipselabs.simpleocl.VariableDeclaration;
import org.eclipselabs.simpleocl.VariableExp;

@SuppressWarnings("all")
public class ExecSemHelper {
  private HashMap<String, String> fMap = new HashMap<String, String>();
  
  public static void main(final String[] args) {
    ExecSemHelper _driver = new ExecSemHelper();
    String _get = args[0];
    String _get_1 = args[1];
    String _get_2 = args[2];
    _driver.generate(_get, _get_1, _get_2);
    
  }
  
  public void generate(final String file, final String mm, final String path) {
    try {
      this.doEMFSetup();
      final ResourceSetImpl rs = new ResourceSetImpl();
      URI _createURI = URI.createURI(file);
      final Resource resource = rs.getResource(_createURI, true);
      URI _createURI_1 = URI.createURI(mm);
      Resource srcmm = rs.getResource(_createURI_1, true);
      HashMap<String, String> _sfInfo = this.getsfInfo(srcmm);
      this.fMap = _sfInfo;
      EList<EObject> _contents = resource.getContents();
      for (final EObject content : _contents) {
        {
          CharSequence _generateModule_applys = this.generateModule_applys(content);
          File _file = new File((path + "ATL_apply.bpl"));
          Files.write(_generateModule_applys, _file, Charsets.UTF_8);
          CharSequence _generateModule_matches = this.generateModule_matches(content);
          File _file_1 = new File((path + "ATL_match.bpl"));
          Files.write(_generateModule_matches, _file_1, Charsets.UTF_8);
          CharSequence _generateModule_sfs = this.generateModule_sfs(content);
          File _file_2 = new File((path + "StructuralPatternMatching.bpl"));
          Files.write(_generateModule_sfs, _file_2, Charsets.UTF_8);
        }
      }
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public HashMap<String, String> getsfInfo(final Resource resource) {
    HashMap<String, String> r = new HashMap<String, String>();
    EList<EObject> _contents = resource.getContents();
    for (final EObject content : _contents) {
      if ((content instanceof EPackage)) {
        EList<EClassifier> _eClassifiers = ((EPackage)content).getEClassifiers();
        for (final EClassifier c : _eClassifiers) {
          if ((c instanceof EClass)) {
            EList<EStructuralFeature> _eStructuralFeatures = ((EClass)c).getEStructuralFeatures();
            for (final EStructuralFeature sf : _eStructuralFeatures) {
              {
                String _name = ((EPackage)content).getName();
                String _name_1 = ((EClass)c).getName();
                String _name_2 = sf.getName();
                String nm = String.format("%s$%s.%s", _name, _name_1, _name_2);
                EClassifier _eType = sf.getEType();
                String _name_3 = _eType.getName();
                boolean _equals = Objects.equal(_name_3, "EInt");
                if (_equals) {
                  r.put(nm, "int");
                } else {
                  EClassifier _eType_1 = sf.getEType();
                  String _name_4 = _eType_1.getName();
                  boolean _equals_1 = Objects.equal(_name_4, "EString");
                  if (_equals_1) {
                    r.put(nm, "string");
                  } else {
                    EClassifier _eType_2 = sf.getEType();
                    String _name_5 = _eType_2.getName();
                    boolean _equals_2 = Objects.equal(_name_5, "EBoolean");
                    if (_equals_2) {
                      r.put(nm, "bool");
                    } else {
                      r.put(nm, "ref");
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return r;
  }
  
  public boolean isPrimitive(final String s) {
    boolean _xifexpression = false;
    boolean _or = false;
    boolean _or_1 = false;
    boolean _equals = Objects.equal(s, "int");
    if (_equals) {
      _or_1 = true;
    } else {
      boolean _equals_1 = Objects.equal(s, "string");
      _or_1 = _equals_1;
    }
    if (_or_1) {
      _or = true;
    } else {
      boolean _equals_2 = Objects.equal(s, "bool");
      _or = _equals_2;
    }
    if (_or) {
      _xifexpression = true;
    } else {
      _xifexpression = false;
    }
    return _xifexpression;
  }
  
  public Object doEMFSetup() {
    Object _xblockexpression = null;
    {
      EPackage.Registry.INSTANCE.put("http://eclipselabs.org/simplegt/2013/SimpleOCL", SimpleoclPackage.eINSTANCE);
      EPackage.Registry.INSTANCE.put("http://eclipselabs.org/simplegt/2013/SimpleGT", SimplegtPackage.eINSTANCE);
      Map<String, Object> _extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap();
      XMIResourceFactoryImpl _xMIResourceFactoryImpl = new XMIResourceFactoryImpl();
      _extensionToFactoryMap.put("xmi", _xMIResourceFactoryImpl);
      Map<String, Object> _extensionToFactoryMap_1 = Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap();
      SimplegtResourceFactory _simplegtResourceFactory = new SimplegtResourceFactory();
      _extensionToFactoryMap_1.put("simplegt", _simplegtResourceFactory);
      Map<String, Object> _extensionToFactoryMap_2 = Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap();
      EcoreResourceFactoryImpl _ecoreResourceFactoryImpl = new EcoreResourceFactoryImpl();
      _xblockexpression = _extensionToFactoryMap_2.put("ecore", _ecoreResourceFactoryImpl);
    }
    return _xblockexpression;
  }
  
  /**
   * Code generation starts
   */
  protected CharSequence _generateModule_applys(final EObject it) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("_PlaceHolder");
    _builder.newLine();
    return _builder;
  }
  
  protected CharSequence _generateModule_applys(final Module mod) {
    StringConcatenation _builder = new StringConcatenation();
    {
      EList<ModuleElement> _elements = mod.getElements();
      for(final ModuleElement e : _elements) {
        CharSequence _genModuleElement_apply = this.genModuleElement_apply(e);
        _builder.append(_genModuleElement_apply, "");
        _builder.newLineIfNotEmpty();
        _builder.newLine();
      }
    }
    return _builder;
  }
  
  protected CharSequence _generateModule_matches(final EObject it) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("_PlaceHolder");
    _builder.newLine();
    return _builder;
  }
  
  protected CharSequence _generateModule_matches(final Module mod) {
    StringConcatenation _builder = new StringConcatenation();
    {
      EList<ModuleElement> _elements = mod.getElements();
      for(final ModuleElement e : _elements) {
        CharSequence _genModuleElement_match = this.genModuleElement_match(e);
        _builder.append(_genModuleElement_match, "");
        _builder.newLineIfNotEmpty();
        _builder.newLine();
      }
    }
    return _builder;
  }
  
  protected CharSequence _generateModule_sfs(final EObject it) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("_PlaceHolder");
    _builder.newLine();
    return _builder;
  }
  
  protected CharSequence _generateModule_sfs(final Module mod) {
    StringConcatenation _builder = new StringConcatenation();
    {
      EList<ModuleElement> _elements = mod.getElements();
      for(final ModuleElement e : _elements) {
        CharSequence _genStructuralPatternMatch = this.genStructuralPatternMatch(e);
        _builder.append(_genStructuralPatternMatch, "");
        _builder.append("\t");
        _builder.newLineIfNotEmpty();
      }
    }
    return _builder;
  }
  
  protected CharSequence _genModuleElement_apply(final ModuleElement element) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("_PlaceHolder");
    _builder.newLine();
    return _builder;
  }
  
  protected CharSequence _genModuleElement_match(final ModuleElement element) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("_PlaceHolder");
    _builder.newLine();
    return _builder;
  }
  
  protected CharSequence _genStructuralPatternMatch(final ModuleElement element) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("_PlaceHolder");
    _builder.newLine();
    return _builder;
  }
  
  public String genOutputElementType(final OutputElement e) {
    OclType _type = e.getType();
    String _model = this.getModel(_type);
    String _plus = (_model + "$");
    OclType _type_1 = e.getType();
    String _name = _type_1.getName();
    return (_plus + _name);
  }
  
  public String genIutputElementType(final InputElement e) {
    OclType _type = e.getType();
    String _model = this.getModel(_type);
    String _plus = (_model + "$");
    OclType _type_1 = e.getType();
    String _name = _type_1.getName();
    return (_plus + _name);
  }
  
  public String genModelElementType(final VariableDeclaration v) {
    OclType _type = v.getType();
    String _model = this.getModel(_type);
    String _plus = (_model + "$");
    OclType _type_1 = v.getType();
    String _name = _type_1.getName();
    return (_plus + _name);
  }
  
  protected CharSequence _genStructuralPatternMatch(final Rule r) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("function findPatterns_");
    String _name = r.getName();
    _builder.append(_name, "");
    _builder.append("(");
    String _bHeap = this.getBHeap();
    _builder.append(_bHeap, "");
    _builder.append(": HeapType): Seq (Seq ref);");
    _builder.newLineIfNotEmpty();
    _builder.append("// structure filter");
    _builder.newLine();
    _builder.append("axiom (forall ");
    String _bHeap_1 = this.getBHeap();
    _builder.append(_bHeap_1, "");
    _builder.append(": HeapType :: Seq#Length(findPatterns_");
    String _name_1 = r.getName();
    _builder.append(_name_1, "");
    _builder.append("(");
    String _bHeap_2 = this.getBHeap();
    _builder.append(_bHeap_2, "");
    _builder.append(")) >= 0);");
    _builder.newLineIfNotEmpty();
    _builder.append("// input elements size");
    _builder.newLine();
    _builder.append("axiom (forall ");
    String _bHeap_3 = this.getBHeap();
    _builder.append(_bHeap_3, "");
    _builder.append(": HeapType ::");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("(forall i: int :: inRange(i,0,Seq#Length(findPatterns_");
    String _name_2 = r.getName();
    _builder.append(_name_2, "\t");
    _builder.append("(");
    String _bHeap_4 = this.getBHeap();
    _builder.append(_bHeap_4, "\t");
    _builder.append("))) ==> ");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t");
    _builder.append("Seq#Length(Seq#Index(findPatterns_");
    String _name_3 = r.getName();
    _builder.append(_name_3, "\t\t");
    _builder.append("(");
    String _bHeap_5 = this.getBHeap();
    _builder.append(_bHeap_5, "\t\t");
    _builder.append("),i)) == ");
    InPattern _input = r.getInput();
    EList<InputElement> _elements = _input.getElements();
    int _size = _elements.size();
    _builder.append(_size, "\t\t");
    _builder.append(")");
    _builder.newLineIfNotEmpty();
    _builder.append(");");
    _builder.newLine();
    int it = 0;
    _builder.newLineIfNotEmpty();
    {
      InPattern _input_1 = r.getInput();
      EList<InputElement> _elements_1 = _input_1.getElements();
      for(final InputElement i : _elements_1) {
        _builder.append("// ");
        String _varName = i.getVarName();
        _builder.append(_varName, "");
        _builder.append(" != null && read(");
        String _bHeap_6 = this.getBHeap();
        _builder.append(_bHeap_6, "");
        _builder.append(", ");
        String _varName_1 = i.getVarName();
        _builder.append(_varName_1, "");
        _builder.append(", alloc) && dtype(");
        String _varName_2 = i.getVarName();
        _builder.append(_varName_2, "");
        _builder.append(") <: ");
        String _genIutputElementType = this.genIutputElementType(i);
        _builder.append(_genIutputElementType, "");
        _builder.append(";");
        _builder.newLineIfNotEmpty();
        _builder.append("axiom (forall ");
        String _bHeap_7 = this.getBHeap();
        _builder.append(_bHeap_7, "");
        _builder.append(": HeapType ::\t");
        _builder.newLineIfNotEmpty();
        _builder.append("\t");
        _builder.append("(forall i: int :: inRange(i,0,Seq#Length(findPatterns_");
        String _name_4 = r.getName();
        _builder.append(_name_4, "\t");
        _builder.append("(");
        String _bHeap_8 = this.getBHeap();
        _builder.append(_bHeap_8, "\t");
        _builder.append("))) ==> ");
        _builder.newLineIfNotEmpty();
        _builder.append("\t\t");
        _builder.append("Seq#Index(Seq#Index(findPatterns_");
        String _name_5 = r.getName();
        _builder.append(_name_5, "\t\t");
        _builder.append("(");
        String _bHeap_9 = this.getBHeap();
        _builder.append(_bHeap_9, "\t\t");
        _builder.append("),i),");
        _builder.append(it, "\t\t");
        _builder.append(") != null ");
        _builder.newLineIfNotEmpty();
        _builder.append("\t\t");
        _builder.append("&& read(");
        String _bHeap_10 = this.getBHeap();
        _builder.append(_bHeap_10, "\t\t");
        _builder.append(",Seq#Index(Seq#Index(findPatterns_");
        String _name_6 = r.getName();
        _builder.append(_name_6, "\t\t");
        _builder.append("(");
        String _bHeap_11 = this.getBHeap();
        _builder.append(_bHeap_11, "\t\t");
        _builder.append("),i), ");
        _builder.append(it, "\t\t");
        _builder.append("),alloc) ");
        _builder.newLineIfNotEmpty();
        _builder.append("\t\t");
        _builder.append("&& dtype(Seq#Index(Seq#Index(findPatterns_");
        String _name_7 = r.getName();
        _builder.append(_name_7, "\t\t");
        _builder.append("(");
        String _bHeap_12 = this.getBHeap();
        _builder.append(_bHeap_12, "\t\t");
        _builder.append("),i),");
        _builder.append(it, "\t\t");
        _builder.append(")) == ");
        String _genIutputElementType_1 = this.genIutputElementType(i);
        _builder.append(_genIutputElementType_1, "\t\t");
        _builder.newLineIfNotEmpty();
        _builder.append("\t ");
        _builder.append(")");
        _builder.newLine();
        _builder.append(");");
        _builder.newLine();
        String _xblockexpression = null;
        {
          it = (it + 1);
          _xblockexpression = "";
        }
        _builder.append(_xblockexpression, "");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("//injective matching");
    _builder.newLine();
    int it1 = 0;
    _builder.append("\t");
    _builder.newLineIfNotEmpty();
    {
      InPattern _input_2 = r.getInput();
      EList<InputElement> _elements_2 = _input_2.getElements();
      for(final InputElement i_1 : _elements_2) {
        int it2 = it1;
        _builder.newLineIfNotEmpty();
        {
          InPattern _input_3 = r.getInput();
          EList<InputElement> _elements_3 = _input_3.getElements();
          InPattern _input_4 = r.getInput();
          EList<InputElement> _elements_4 = _input_4.getElements();
          int _indexOf = _elements_4.indexOf(i_1);
          InPattern _input_5 = r.getInput();
          EList<InputElement> _elements_5 = _input_5.getElements();
          int _size_1 = _elements_5.size();
          List<InputElement> _subList = _elements_3.subList(_indexOf, _size_1);
          for(final InputElement j : _subList) {
            {
              boolean _and = false;
              boolean _notEquals = (!Objects.equal(i_1, j));
              if (!_notEquals) {
                _and = false;
              } else {
                String _genIutputElementType_2 = this.genIutputElementType(i_1);
                String _genIutputElementType_3 = this.genIutputElementType(j);
                boolean _equals = Objects.equal(_genIutputElementType_2, _genIutputElementType_3);
                _and = _equals;
              }
              if (_and) {
                _builder.append("axiom (forall ");
                String _bHeap_13 = this.getBHeap();
                _builder.append(_bHeap_13, "");
                _builder.append(": HeapType ::");
                _builder.newLineIfNotEmpty();
                _builder.append("\t\t");
                _builder.append("(forall i: int :: inRange(i,0,Seq#Length(findPatterns_");
                String _name_8 = r.getName();
                _builder.append(_name_8, "\t\t");
                _builder.append("(");
                String _bHeap_14 = this.getBHeap();
                _builder.append(_bHeap_14, "\t\t");
                _builder.append("))) ==> ");
                _builder.newLineIfNotEmpty();
                _builder.append("\t\t\t");
                _builder.append("Seq#Index(Seq#Index(findPatterns_");
                String _name_9 = r.getName();
                _builder.append(_name_9, "\t\t\t");
                _builder.append("(");
                String _bHeap_15 = this.getBHeap();
                _builder.append(_bHeap_15, "\t\t\t");
                _builder.append("),i),");
                _builder.append(it1, "\t\t\t");
                _builder.append(") != Seq#Index(Seq#Index(findPatterns_");
                String _name_10 = r.getName();
                _builder.append(_name_10, "\t\t\t");
                _builder.append("(");
                String _bHeap_16 = this.getBHeap();
                _builder.append(_bHeap_16, "\t\t\t");
                _builder.append("),i),");
                _builder.append(it2, "\t\t\t");
                _builder.append(")));");
                _builder.newLineIfNotEmpty();
              }
            }
            String _xblockexpression_1 = null;
            {
              it2 = (it2 + 1);
              _xblockexpression_1 = "";
            }
            _builder.append(_xblockexpression_1, "");
            _builder.newLineIfNotEmpty();
          }
        }
        String _xblockexpression_2 = null;
        {
          it1 = (it1 + 1);
          _xblockexpression_2 = "";
        }
        _builder.append(_xblockexpression_2, "");
        _builder.newLineIfNotEmpty();
      }
    }
    {
      InPattern _input_6 = r.getInput();
      EList<InputElement> _elements_6 = _input_6.getElements();
      for(final InputElement i_2 : _elements_6) {
        {
          EList<InputBinding> _bindings = i_2.getBindings();
          for(final InputBinding b : _bindings) {
            {
              String _genIutputElementType_4 = this.genIutputElementType(i_2);
              String _plus = (_genIutputElementType_4 + ".");
              String _property = b.getProperty();
              String _plus_1 = (_plus + _property);
              String _get = this.fMap.get(_plus_1);
              boolean _isPrimitive = this.isPrimitive(_get);
              if (_isPrimitive) {
              } else {
                OclExpression _expr = b.getExpr();
                if ((_expr instanceof VariableExp)) {
                  OclExpression _expr_1 = b.getExpr();
                  VariableDeclaration _referredVariable = ((VariableExp) _expr_1).getReferredVariable();
                  String bind = _referredVariable.getVarName();
                  _builder.newLineIfNotEmpty();
                  _builder.append("// structural matching");
                  _builder.newLine();
                  _builder.append("axiom (forall ");
                  String _bHeap_17 = this.getBHeap();
                  _builder.append(_bHeap_17, "");
                  _builder.append(": HeapType ::");
                  _builder.newLineIfNotEmpty();
                  _builder.append("\t");
                  _builder.append("(forall i: int :: inRange(i,0,Seq#Length(findPatterns_");
                  String _name_11 = r.getName();
                  _builder.append(_name_11, "\t");
                  _builder.append("(");
                  String _bHeap_18 = this.getBHeap();
                  _builder.append(_bHeap_18, "\t");
                  _builder.append("))) ==> ");
                  _builder.newLineIfNotEmpty();
                  _builder.append("\t\t ");
                  _builder.append("read(");
                  String _bHeap_19 = this.getBHeap();
                  _builder.append(_bHeap_19, "\t\t ");
                  _builder.append(", ");
                  InPattern _input_7 = r.getInput();
                  EList<InputElement> _elements_7 = _input_7.getElements();
                  String _varName_3 = i_2.getVarName();
                  String _genInputElementIndex = this.genInputElementIndex(r, _elements_7, _varName_3);
                  _builder.append(_genInputElementIndex, "\t\t ");
                  _builder.append(", ");
                  String _genIutputElementType_5 = this.genIutputElementType(i_2);
                  _builder.append(_genIutputElementType_5, "\t\t ");
                  _builder.append(".");
                  String _property_1 = b.getProperty();
                  _builder.append(_property_1, "\t\t ");
                  _builder.append(") == ");
                  InPattern _input_8 = r.getInput();
                  EList<InputElement> _elements_8 = _input_8.getElements();
                  String _genInputElementIndex_1 = this.genInputElementIndex(r, _elements_8, bind);
                  _builder.append(_genInputElementIndex_1, "\t\t ");
                  _builder.newLineIfNotEmpty();
                  _builder.append("\t");
                  _builder.append(")");
                  _builder.newLine();
                  _builder.append(");");
                  _builder.newLine();
                } else {
                  _builder.append("error, case analysis failed, not recognised PAC pattern.");
                  _builder.newLine();
                }
              }
            }
          }
        }
      }
    }
    _builder.append("// surjective");
    _builder.newLine();
    _builder.append("axiom (forall ");
    String _bHeap_20 = this.getBHeap();
    _builder.append(_bHeap_20, "");
    _builder.append(": HeapType ::");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("(forall ");
    {
      InPattern _input_9 = r.getInput();
      EList<InputElement> _elements_9 = _input_9.getElements();
      boolean _hasElements = false;
      for(final InputElement i_3 : _elements_9) {
        if (!_hasElements) {
          _hasElements = true;
        } else {
          _builder.appendImmediate(", ", "\t");
        }
        String _varName_4 = i_3.getVarName();
        _builder.append(_varName_4, "\t");
      }
    }
    _builder.append(": ref ::");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t");
    _builder.append("true");
    _builder.newLine();
    {
      InPattern _input_10 = r.getInput();
      EList<InputElement> _elements_10 = _input_10.getElements();
      for(final InputElement i_4 : _elements_10) {
        _builder.append("\t\t");
        _builder.append("&& ");
        String _varName_5 = i_4.getVarName();
        _builder.append(_varName_5, "\t\t");
        _builder.append(" != null && read(");
        String _bHeap_21 = this.getBHeap();
        _builder.append(_bHeap_21, "\t\t");
        _builder.append(", ");
        String _varName_6 = i_4.getVarName();
        _builder.append(_varName_6, "\t\t");
        _builder.append(", alloc) && dtype(");
        String _varName_7 = i_4.getVarName();
        _builder.append(_varName_7, "\t\t");
        _builder.append(") <: ");
        String _genIutputElementType_6 = this.genIutputElementType(i_4);
        _builder.append(_genIutputElementType_6, "\t\t");
        _builder.newLineIfNotEmpty();
      }
    }
    {
      InPattern _input_11 = r.getInput();
      EList<InputElement> _elements_11 = _input_11.getElements();
      for(final InputElement i_5 : _elements_11) {
        {
          InPattern _input_12 = r.getInput();
          EList<InputElement> _elements_12 = _input_12.getElements();
          InPattern _input_13 = r.getInput();
          EList<InputElement> _elements_13 = _input_13.getElements();
          int _indexOf_1 = _elements_13.indexOf(i_5);
          InPattern _input_14 = r.getInput();
          EList<InputElement> _elements_14 = _input_14.getElements();
          int _size_2 = _elements_14.size();
          List<InputElement> _subList_1 = _elements_12.subList(_indexOf_1, _size_2);
          for(final InputElement j_1 : _subList_1) {
            {
              boolean _and_1 = false;
              boolean _notEquals_1 = (!Objects.equal(i_5, j_1));
              if (!_notEquals_1) {
                _and_1 = false;
              } else {
                String _genIutputElementType_7 = this.genIutputElementType(i_5);
                String _genIutputElementType_8 = this.genIutputElementType(j_1);
                boolean _equals_1 = Objects.equal(_genIutputElementType_7, _genIutputElementType_8);
                _and_1 = _equals_1;
              }
              if (_and_1) {
                _builder.append("\t\t");
                _builder.append("&& ");
                String _varName_8 = i_5.getVarName();
                _builder.append(_varName_8, "\t\t");
                _builder.append(" != ");
                String _varName_9 = j_1.getVarName();
                _builder.append(_varName_9, "\t\t");
                _builder.newLineIfNotEmpty();
              }
            }
          }
        }
      }
    }
    {
      InPattern _input_15 = r.getInput();
      EList<InputElement> _elements_15 = _input_15.getElements();
      for(final InputElement i_6 : _elements_15) {
        {
          EList<InputBinding> _bindings_1 = i_6.getBindings();
          for(final InputBinding b_1 : _bindings_1) {
            {
              String _genIutputElementType_9 = this.genIutputElementType(i_6);
              String _plus_2 = (_genIutputElementType_9 + ".");
              String _property_2 = b_1.getProperty();
              String _plus_3 = (_plus_2 + _property_2);
              String _get_1 = this.fMap.get(_plus_3);
              boolean _isPrimitive_1 = this.isPrimitive(_get_1);
              if (_isPrimitive_1) {
              } else {
                OclExpression _expr_2 = b_1.getExpr();
                if ((_expr_2 instanceof VariableExp)) {
                  _builder.append("\t\t");
                  _builder.append("&& read(");
                  String _bHeap_22 = this.getBHeap();
                  _builder.append(_bHeap_22, "\t\t");
                  _builder.append(", ");
                  String _varName_10 = i_6.getVarName();
                  _builder.append(_varName_10, "\t\t");
                  _builder.append(", ");
                  String _genIutputElementType_10 = this.genIutputElementType(i_6);
                  _builder.append(_genIutputElementType_10, "\t\t");
                  _builder.append(".");
                  String _property_3 = b_1.getProperty();
                  _builder.append(_property_3, "\t\t");
                  _builder.append(") == ");
                  OclExpression _expr_3 = b_1.getExpr();
                  CharSequence _printOCL = this.printOCL(_expr_3, false);
                  _builder.append(_printOCL, "\t\t");
                  _builder.newLineIfNotEmpty();
                } else {
                  _builder.append("\t\t");
                  _builder.append("error, case analysis failed, not recognised PAC pattern.");
                  _builder.newLine();
                }
              }
            }
          }
        }
      }
    }
    _builder.append("\t\t");
    _builder.append("==> \t");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("Seq#Contains(findPatterns_");
    String _name_12 = r.getName();
    _builder.append(_name_12, "\t\t");
    _builder.append("(");
    String _bHeap_23 = this.getBHeap();
    _builder.append(_bHeap_23, "\t\t");
    _builder.append("), ");
    InPattern _input_16 = r.getInput();
    EList<InputElement> _elements_16 = _input_16.getElements();
    String _genInputSequence = this.genInputSequence(_elements_16);
    _builder.append(_genInputSequence, "\t\t");
    _builder.append(")");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append(")\t");
    _builder.newLine();
    _builder.append(");\t");
    _builder.newLine();
    _builder.newLine();
    _builder.newLine();
    _builder.newLine();
    _builder.newLine();
    return _builder;
  }
  
  public String genInputElementIndex(final Rule r, final EList<InputElement> list, final String s) {
    int i = 0;
    String res = "";
    for (final InputElement e : list) {
      {
        String _varName = e.getVarName();
        boolean _equals = Objects.equal(_varName, s);
        if (_equals) {
          String _name = r.getName();
          String _bHeap = this.getBHeap();
          String _format = String.format("Seq#Index(Seq#Index(findPatterns_%s(%s),i), %s)", _name, _bHeap, Integer.valueOf(i));
          res = _format;
        }
        i = (i + 1);
      }
    }
    return res;
  }
  
  public ArrayList<InputElement> genNacInMatch(final EList<NacPattern> nac, final EList<InputElement> inputs) {
    ArrayList<InputElement> r = new ArrayList<InputElement>();
    for (final NacPattern n : nac) {
      EList<InputElement> _elements = n.getElements();
      for (final InputElement e : _elements) {
        {
          boolean add = true;
          for (final InputElement i : inputs) {
            String _varName = e.getVarName();
            String _varName_1 = i.getVarName();
            boolean _equals = Objects.equal(_varName, _varName_1);
            if (_equals) {
              add = false;
            }
          }
          if (add) {
            r.add(e);
          }
        }
      }
    }
    return r;
  }
  
  protected CharSequence _genModuleElement_match(final Rule r) {
    StringConcatenation _builder = new StringConcatenation();
    EList<NacPattern> _nac = r.getNac();
    InPattern _input = r.getInput();
    EList<InputElement> _elements = _input.getElements();
    ArrayList<InputElement> nac = this.genNacInMatch(_nac, _elements);
    _builder.newLineIfNotEmpty();
    _builder.append("procedure ");
    String _name = r.getName();
    _builder.append(_name, "");
    _builder.append("_match(");
    {
      InPattern _input_1 = r.getInput();
      EList<InputElement> _elements_1 = _input_1.getElements();
      boolean _hasElements = false;
      for(final InputElement i : _elements_1) {
        if (!_hasElements) {
          _hasElements = true;
        } else {
          _builder.appendImmediate(", ", "");
        }
        String _varName = i.getVarName();
        _builder.append(_varName, "");
        _builder.append(": ref");
      }
    }
    {
      int _size = nac.size();
      boolean _notEquals = (_size != 0);
      if (_notEquals) {
        _builder.append(", ");
        {
          boolean _hasElements_1 = false;
          for(final InputElement e : nac) {
            if (!_hasElements_1) {
              _hasElements_1 = true;
            } else {
              _builder.appendImmediate(", ", "");
            }
            String _varName_1 = e.getVarName();
            _builder.append(_varName_1, "");
            _builder.append(": ref");
          }
        }
      }
    }
    _builder.append(") returns (r: bool);");
    _builder.newLineIfNotEmpty();
    _builder.append("// alloc");
    _builder.newLine();
    {
      InPattern _input_2 = r.getInput();
      EList<InputElement> _elements_2 = _input_2.getElements();
      for(final InputElement i_1 : _elements_2) {
        _builder.append("requires ");
        String _varName_2 = i_1.getVarName();
        _builder.append(_varName_2, "");
        _builder.append(" != null && read(");
        String _heapName = this.getHeapName();
        _builder.append(_heapName, "");
        _builder.append(", ");
        String _varName_3 = i_1.getVarName();
        _builder.append(_varName_3, "");
        _builder.append(", alloc) && dtype(");
        String _varName_4 = i_1.getVarName();
        _builder.append(_varName_4, "");
        _builder.append(") <: ");
        String _genIutputElementType = this.genIutputElementType(i_1);
        _builder.append(_genIutputElementType, "");
        _builder.append(";");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("//injective matching");
    _builder.newLine();
    {
      InPattern _input_3 = r.getInput();
      EList<InputElement> _elements_3 = _input_3.getElements();
      for(final InputElement i_2 : _elements_3) {
        {
          InPattern _input_4 = r.getInput();
          EList<InputElement> _elements_4 = _input_4.getElements();
          InPattern _input_5 = r.getInput();
          EList<InputElement> _elements_5 = _input_5.getElements();
          int _indexOf = _elements_5.indexOf(i_2);
          InPattern _input_6 = r.getInput();
          EList<InputElement> _elements_6 = _input_6.getElements();
          int _size_1 = _elements_6.size();
          List<InputElement> _subList = _elements_4.subList(_indexOf, _size_1);
          for(final InputElement j : _subList) {
            {
              boolean _and = false;
              boolean _notEquals_1 = (!Objects.equal(i_2, j));
              if (!_notEquals_1) {
                _and = false;
              } else {
                String _genIutputElementType_1 = this.genIutputElementType(i_2);
                String _genIutputElementType_2 = this.genIutputElementType(j);
                boolean _equals = Objects.equal(_genIutputElementType_1, _genIutputElementType_2);
                _and = _equals;
              }
              if (_and) {
                _builder.append("requires ");
                String _varName_5 = i_2.getVarName();
                _builder.append(_varName_5, "");
                _builder.append(" != ");
                String _varName_6 = j.getVarName();
                _builder.append(_varName_6, "");
                _builder.append(";");
                _builder.newLineIfNotEmpty();
              }
            }
          }
        }
      }
    }
    _builder.append("// structural matching");
    _builder.newLine();
    {
      InPattern _input_7 = r.getInput();
      EList<InputElement> _elements_7 = _input_7.getElements();
      for(final InputElement i_3 : _elements_7) {
        {
          EList<InputBinding> _bindings = i_3.getBindings();
          for(final InputBinding b : _bindings) {
            {
              String _genIutputElementType_3 = this.genIutputElementType(i_3);
              String _plus = (_genIutputElementType_3 + ".");
              String _property = b.getProperty();
              String _plus_1 = (_plus + _property);
              String _get = this.fMap.get(_plus_1);
              boolean _isPrimitive = this.isPrimitive(_get);
              if (_isPrimitive) {
              } else {
                OclExpression _expr = b.getExpr();
                if ((_expr instanceof VariableExp)) {
                  _builder.append("requires read(");
                  String _heapName_1 = this.getHeapName();
                  _builder.append(_heapName_1, "");
                  _builder.append(", ");
                  String _varName_7 = i_3.getVarName();
                  _builder.append(_varName_7, "");
                  _builder.append(", ");
                  String _genIutputElementType_4 = this.genIutputElementType(i_3);
                  _builder.append(_genIutputElementType_4, "");
                  _builder.append(".");
                  String _property_1 = b.getProperty();
                  _builder.append(_property_1, "");
                  _builder.append(") == ");
                  OclExpression _expr_1 = b.getExpr();
                  CharSequence _printOCL = this.printOCL(_expr_1, false);
                  _builder.append(_printOCL, "");
                  _builder.append(";");
                  _builder.newLineIfNotEmpty();
                } else {
                  _builder.append("error, case analysis failed, not recognised PAC pattern.");
                  _builder.newLine();
                }
              }
            }
          }
        }
      }
    }
    _builder.append("ensures r <==> (");
    _builder.newLine();
    _builder.append("true");
    _builder.newLine();
    {
      InPattern _input_8 = r.getInput();
      EList<InputElement> _elements_8 = _input_8.getElements();
      for(final InputElement i_4 : _elements_8) {
        {
          EList<InputBinding> _bindings_1 = i_4.getBindings();
          for(final InputBinding b_1 : _bindings_1) {
            {
              String _genIutputElementType_5 = this.genIutputElementType(i_4);
              String _plus_2 = (_genIutputElementType_5 + ".");
              String _property_2 = b_1.getProperty();
              String _plus_3 = (_plus_2 + _property_2);
              String _get_1 = this.fMap.get(_plus_3);
              boolean _isPrimitive_1 = this.isPrimitive(_get_1);
              if (_isPrimitive_1) {
                _builder.append("&& read(");
                String _heapName_2 = this.getHeapName();
                _builder.append(_heapName_2, "");
                _builder.append(", ");
                String _varName_8 = i_4.getVarName();
                _builder.append(_varName_8, "");
                _builder.append(", ");
                String _genIutputElementType_6 = this.genIutputElementType(i_4);
                _builder.append(_genIutputElementType_6, "");
                _builder.append(".");
                String _property_3 = b_1.getProperty();
                _builder.append(_property_3, "");
                _builder.append(") == ");
                OclExpression _expr_2 = b_1.getExpr();
                CharSequence _printOCL_1 = this.printOCL(_expr_2, false);
                _builder.append(_printOCL_1, "");
                _builder.newLineIfNotEmpty();
              }
            }
          }
        }
      }
    }
    {
      EList<NacPattern> _nac_1 = r.getNac();
      for(final NacPattern n : _nac_1) {
        {
          EList<InputElement> _elements_9 = n.getElements();
          for(final InputElement e_1 : _elements_9) {
            {
              EList<InputBinding> _bindings_2 = e_1.getBindings();
              for(final InputBinding b_2 : _bindings_2) {
                {
                  String _genIutputElementType_7 = this.genIutputElementType(e_1);
                  String _plus_4 = (_genIutputElementType_7 + ".");
                  String _property_4 = b_2.getProperty();
                  String _plus_5 = (_plus_4 + _property_4);
                  String _get_2 = this.fMap.get(_plus_5);
                  boolean _isPrimitive_2 = this.isPrimitive(_get_2);
                  if (_isPrimitive_2) {
                    _builder.append("&& read(");
                    String _heapName_3 = this.getHeapName();
                    _builder.append(_heapName_3, "");
                    _builder.append(", ");
                    String _varName_9 = e_1.getVarName();
                    _builder.append(_varName_9, "");
                    _builder.append(", ");
                    String _genIutputElementType_8 = this.genIutputElementType(e_1);
                    _builder.append(_genIutputElementType_8, "");
                    _builder.append(".");
                    String _property_5 = b_2.getProperty();
                    _builder.append(_property_5, "");
                    _builder.append(") != ");
                    OclExpression _expr_3 = b_2.getExpr();
                    CharSequence _printOCL_2 = this.printOCL(_expr_3, false);
                    _builder.append(_printOCL_2, "");
                    _builder.newLineIfNotEmpty();
                  } else {
                    OclExpression _expr_4 = b_2.getExpr();
                    if ((_expr_4 instanceof VariableExp)) {
                      OclExpression _expr_5 = b_2.getExpr();
                      VariableExp bind = ((VariableExp) _expr_5);
                      _builder.newLineIfNotEmpty();
                      {
                        InPattern _input_9 = r.getInput();
                        EList<InputElement> _elements_10 = _input_9.getElements();
                        boolean _contains = _elements_10.contains(bind);
                        if (_contains) {
                          _builder.append("&& read(");
                          String _heapName_4 = this.getHeapName();
                          _builder.append(_heapName_4, "");
                          _builder.append(", ");
                          String _varName_10 = e_1.getVarName();
                          _builder.append(_varName_10, "");
                          _builder.append(", ");
                          String _genIutputElementType_9 = this.genIutputElementType(e_1);
                          _builder.append(_genIutputElementType_9, "");
                          _builder.append(".");
                          String _property_6 = b_2.getProperty();
                          _builder.append(_property_6, "");
                          _builder.append(") != ");
                          OclExpression _expr_6 = b_2.getExpr();
                          CharSequence _printOCL_3 = this.printOCL(_expr_6, false);
                          _builder.append(_printOCL_3, "");
                          _builder.newLineIfNotEmpty();
                        } else {
                          _builder.append("&& !(dtype(read(");
                          String _heapName_5 = this.getHeapName();
                          _builder.append(_heapName_5, "");
                          _builder.append(", ");
                          String _varName_11 = e_1.getVarName();
                          _builder.append(_varName_11, "");
                          _builder.append(", ");
                          String _genIutputElementType_10 = this.genIutputElementType(e_1);
                          _builder.append(_genIutputElementType_10, "");
                          _builder.append(".");
                          String _property_7 = b_2.getProperty();
                          _builder.append(_property_7, "");
                          _builder.append(")) <: ");
                          VariableDeclaration _referredVariable = bind.getReferredVariable();
                          String _genModelElementType = this.genModelElementType(_referredVariable);
                          _builder.append(_genModelElementType, "");
                          _builder.append(")");
                          _builder.newLineIfNotEmpty();
                        }
                      }
                    } else {
                      _builder.append("error, case analysis failed, not recognised nac pattern.");
                      _builder.newLine();
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    _builder.append(");");
    _builder.newLine();
    return _builder;
  }
  
  protected CharSequence _genModuleElement_apply(final Rule r) {
    StringConcatenation _builder = new StringConcatenation();
    OutPattern _output = r.getOutput();
    EList<OutputElement> _elements = _output.getElements();
    InPattern _input = r.getInput();
    EList<InputElement> _elements_1 = _input.getElements();
    ArrayList<OutputElement> addElems = this.listDifference1(_elements, _elements_1);
    _builder.newLineIfNotEmpty();
    OutPattern _output_1 = r.getOutput();
    EList<OutputElement> _elements_2 = _output_1.getElements();
    InPattern _input_1 = r.getInput();
    EList<InputElement> _elements_3 = _input_1.getElements();
    ArrayList<InputElement> delElems = this.listDifference2(_elements_2, _elements_3);
    _builder.newLineIfNotEmpty();
    HashMap<String, OclExpression> ib = new HashMap<String, OclExpression>();
    _builder.append("\t");
    _builder.newLineIfNotEmpty();
    HashMap<String, OclExpression> ob = new HashMap<String, OclExpression>();
    _builder.newLineIfNotEmpty();
    HashMap<String, Set<String>> frame = new HashMap<String, Set<String>>();
    _builder.newLineIfNotEmpty();
    _builder.append("procedure ");
    String _name = r.getName();
    _builder.append(_name, "");
    _builder.append("_apply(__trace__: ref,");
    {
      InPattern _input_2 = r.getInput();
      EList<InputElement> _elements_4 = _input_2.getElements();
      boolean _hasElements = false;
      for(final InputElement i : _elements_4) {
        if (!_hasElements) {
          _hasElements = true;
        } else {
          _builder.appendImmediate(", ", "");
        }
        String _varName = i.getVarName();
        _builder.append(_varName, "");
        _builder.append(": ref");
      }
    }
    {
      int _size = addElems.size();
      boolean _notEquals = (_size != 0);
      if (_notEquals) {
        _builder.append(", ");
        {
          boolean _hasElements_1 = false;
          for(final OutputElement e : addElems) {
            if (!_hasElements_1) {
              _hasElements_1 = true;
            } else {
              _builder.appendImmediate(", ", "");
            }
            String _varName_1 = e.getVarName();
            _builder.append(_varName_1, "");
            _builder.append(": ref");
          }
        }
      }
    }
    _builder.append(" ) returns ();");
    _builder.newLineIfNotEmpty();
    _builder.append("// well_form inputs");
    _builder.newLine();
    _builder.append("requires well_formed(");
    String _heapName = this.getHeapName();
    _builder.append(_heapName, "");
    _builder.append(", ");
    String _setTableName = this.getSetTableName();
    _builder.append(_setTableName, "");
    _builder.append(");");
    _builder.newLineIfNotEmpty();
    _builder.append("// syntactic matching");
    _builder.newLine();
    _builder.append("requires Seq#Contains(findPatterns_");
    String _name_1 = r.getName();
    _builder.append(_name_1, "");
    _builder.append("($srcHeap), ");
    InPattern _input_3 = r.getInput();
    EList<InputElement> _elements_5 = _input_3.getElements();
    String _genInputSequence = this.genInputSequence(_elements_5);
    _builder.append(_genInputSequence, "");
    _builder.append(");");
    _builder.newLineIfNotEmpty();
    _builder.append("// semantic matching");
    _builder.newLine();
    {
      InPattern _input_4 = r.getInput();
      EList<InputElement> _elements_6 = _input_4.getElements();
      for(final InputElement i_1 : _elements_6) {
        {
          EList<InputBinding> _bindings = i_1.getBindings();
          for(final InputBinding b : _bindings) {
            {
              String _genIutputElementType = this.genIutputElementType(i_1);
              String _plus = (_genIutputElementType + ".");
              String _property = b.getProperty();
              String _plus_1 = (_plus + _property);
              String _get = this.fMap.get(_plus_1);
              boolean _isPrimitive = this.isPrimitive(_get);
              if (_isPrimitive) {
                _builder.append("requires read(");
                String _heapName_1 = this.getHeapName();
                _builder.append(_heapName_1, "");
                _builder.append(", ");
                String _varName_2 = i_1.getVarName();
                _builder.append(_varName_2, "");
                _builder.append(", ");
                String _genIutputElementType_1 = this.genIutputElementType(i_1);
                _builder.append(_genIutputElementType_1, "");
                _builder.append(".");
                String _property_1 = b.getProperty();
                _builder.append(_property_1, "");
                _builder.append(") == ");
                OclExpression _expr = b.getExpr();
                CharSequence _printOCL = this.printOCL(_expr, false);
                _builder.append(_printOCL, "");
                _builder.append(";");
                _builder.newLineIfNotEmpty();
              }
            }
          }
        }
      }
    }
    _builder.append("// nac");
    _builder.newLine();
    {
      EList<NacPattern> _nac = r.getNac();
      for(final NacPattern n : _nac) {
        {
          EList<InputElement> _elements_7 = n.getElements();
          for(final InputElement e_1 : _elements_7) {
            {
              EList<InputBinding> _bindings_1 = e_1.getBindings();
              for(final InputBinding b_1 : _bindings_1) {
                {
                  String _genIutputElementType_2 = this.genIutputElementType(e_1);
                  String _plus_2 = (_genIutputElementType_2 + ".");
                  String _property_2 = b_1.getProperty();
                  String _plus_3 = (_plus_2 + _property_2);
                  String _get_1 = this.fMap.get(_plus_3);
                  boolean _isPrimitive_1 = this.isPrimitive(_get_1);
                  if (_isPrimitive_1) {
                    _builder.append("requires read(");
                    String _heapName_2 = this.getHeapName();
                    _builder.append(_heapName_2, "");
                    _builder.append(", ");
                    String _varName_3 = e_1.getVarName();
                    _builder.append(_varName_3, "");
                    _builder.append(", ");
                    String _genIutputElementType_3 = this.genIutputElementType(e_1);
                    _builder.append(_genIutputElementType_3, "");
                    _builder.append(".");
                    String _property_3 = b_1.getProperty();
                    _builder.append(_property_3, "");
                    _builder.append(") != ");
                    OclExpression _expr_1 = b_1.getExpr();
                    CharSequence _printOCL_1 = this.printOCL(_expr_1, false);
                    _builder.append(_printOCL_1, "");
                    _builder.append(";");
                    _builder.newLineIfNotEmpty();
                  } else {
                    OclExpression _expr_2 = b_1.getExpr();
                    if ((_expr_2 instanceof VariableExp)) {
                      OclExpression _expr_3 = b_1.getExpr();
                      VariableExp bind = ((VariableExp) _expr_3);
                      _builder.newLineIfNotEmpty();
                      {
                        InPattern _input_5 = r.getInput();
                        EList<InputElement> _elements_8 = _input_5.getElements();
                        boolean _contains = _elements_8.contains(bind);
                        if (_contains) {
                          _builder.append("requires read(");
                          String _heapName_3 = this.getHeapName();
                          _builder.append(_heapName_3, "");
                          _builder.append(", ");
                          String _varName_4 = e_1.getVarName();
                          _builder.append(_varName_4, "");
                          _builder.append(", ");
                          String _genIutputElementType_4 = this.genIutputElementType(e_1);
                          _builder.append(_genIutputElementType_4, "");
                          _builder.append(".");
                          String _property_4 = b_1.getProperty();
                          _builder.append(_property_4, "");
                          _builder.append(") != ");
                          OclExpression _expr_4 = b_1.getExpr();
                          CharSequence _printOCL_2 = this.printOCL(_expr_4, false);
                          _builder.append(_printOCL_2, "");
                          _builder.append(";");
                          _builder.newLineIfNotEmpty();
                        } else {
                          _builder.append("requires !(dtype(read(");
                          String _heapName_4 = this.getHeapName();
                          _builder.append(_heapName_4, "");
                          _builder.append(", ");
                          String _varName_5 = e_1.getVarName();
                          _builder.append(_varName_5, "");
                          _builder.append(", ");
                          String _genIutputElementType_5 = this.genIutputElementType(e_1);
                          _builder.append(_genIutputElementType_5, "");
                          _builder.append(".");
                          String _property_5 = b_1.getProperty();
                          _builder.append(_property_5, "");
                          _builder.append(")) <: ");
                          VariableDeclaration _referredVariable = bind.getReferredVariable();
                          String _genModelElementType = this.genModelElementType(_referredVariable);
                          _builder.append(_genModelElementType, "");
                          _builder.append(");");
                          _builder.newLineIfNotEmpty();
                        }
                      }
                    } else {
                      _builder.append("error, case analysis failed, not recognised nac pattern.");
                      _builder.newLine();
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    _builder.append("// acc of structural/semantic matching");
    _builder.newLine();
    {
      InPattern _input_6 = r.getInput();
      EList<InputElement> _elements_9 = _input_6.getElements();
      for(final InputElement i_2 : _elements_9) {
        {
          EList<InputBinding> _bindings_2 = i_2.getBindings();
          for(final InputBinding b_2 : _bindings_2) {
            _builder.append("requires isset(");
            String _setTableName_1 = this.getSetTableName();
            _builder.append(_setTableName_1, "");
            _builder.append(", ");
            String _varName_6 = i_2.getVarName();
            _builder.append(_varName_6, "");
            _builder.append(", ");
            String _genIutputElementType_6 = this.genIutputElementType(i_2);
            _builder.append(_genIutputElementType_6, "");
            _builder.append(".");
            String _property_6 = b_2.getProperty();
            _builder.append(_property_6, "");
            _builder.append(");");
            _builder.newLineIfNotEmpty();
          }
        }
      }
    }
    _builder.append("// add elements are allocated with correct type");
    _builder.newLine();
    {
      for(final OutputElement o : addElems) {
        _builder.append("requires ");
        String _varName_7 = o.getVarName();
        _builder.append(_varName_7, "");
        _builder.append(" != null && read(");
        String _heapName_5 = this.getHeapName();
        _builder.append(_heapName_5, "");
        _builder.append(", ");
        String _varName_8 = o.getVarName();
        _builder.append(_varName_8, "");
        _builder.append(", alloc);");
        _builder.newLineIfNotEmpty();
        _builder.append("requires (forall<alpha> f: Field alpha :: f!=alloc ==> !isset(");
        String _setTableName_2 = this.getSetTableName();
        _builder.append(_setTableName_2, "");
        _builder.append(", ");
        String _varName_9 = o.getVarName();
        _builder.append(_varName_9, "");
        _builder.append(", f));");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("modifies ");
    String _heapName_6 = this.getHeapName();
    _builder.append(_heapName_6, "");
    _builder.append(", ");
    String _setTableName_3 = this.getSetTableName();
    _builder.append(_setTableName_3, "");
    _builder.append(";");
    _builder.newLineIfNotEmpty();
    _builder.append("ensures well_formed(");
    String _heapName_7 = this.getHeapName();
    _builder.append(_heapName_7, "");
    _builder.append(", ");
    String _setTableName_4 = this.getSetTableName();
    _builder.append(_setTableName_4, "");
    _builder.append(");");
    _builder.newLineIfNotEmpty();
    {
      for(final InputElement e_2 : delElems) {
        _builder.append("ensures ! read(");
        String _heapName_8 = this.getHeapName();
        _builder.append(_heapName_8, "");
        _builder.append(", ");
        String _varName_10 = e_2.getVarName();
        _builder.append(_varName_10, "");
        _builder.append(", alloc);");
        _builder.newLineIfNotEmpty();
        {
          String _varName_11 = e_2.getVarName();
          boolean _containsKey = frame.containsKey(_varName_11);
          if (_containsKey) {
            String _xblockexpression = null;
            {
              String _varName_12 = e_2.getVarName();
              Set<String> _get_2 = frame.get(_varName_12);
              _get_2.add("alloc");
              _xblockexpression = "";
            }
            _builder.append(_xblockexpression, "");
            _builder.newLineIfNotEmpty();
          } else {
            String _xblockexpression_1 = null;
            {
              String _varName_12 = e_2.getVarName();
              HashSet<String> _hashSet = new HashSet<String>();
              frame.put(_varName_12, _hashSet);
              _xblockexpression_1 = "";
            }
            _builder.append(_xblockexpression_1, "");
            _builder.newLineIfNotEmpty();
            String _xblockexpression_2 = null;
            {
              String _varName_12 = e_2.getVarName();
              Set<String> _get_2 = frame.get(_varName_12);
              _get_2.add("alloc");
              _xblockexpression_2 = "";
            }
            _builder.append(_xblockexpression_2, "");
            _builder.newLineIfNotEmpty();
          }
        }
      }
    }
    {
      InPattern _input_7 = r.getInput();
      EList<InputElement> _elements_10 = _input_7.getElements();
      for(final InputElement i_3 : _elements_10) {
        {
          EList<InputBinding> _bindings_3 = i_3.getBindings();
          boolean _notEquals_1 = (!Objects.equal(_bindings_3, null));
          if (_notEquals_1) {
            {
              EList<InputBinding> _bindings_4 = i_3.getBindings();
              for(final InputBinding b_3 : _bindings_4) {
                String _varName_12 = i_3.getVarName();
                String _plus_4 = (_varName_12 + "_sep_");
                String _genIutputElementType_7 = this.genIutputElementType(i_3);
                String _plus_5 = (_plus_4 + _genIutputElementType_7);
                String _plus_6 = (_plus_5 + ".");
                String _property_7 = b_3.getProperty();
                String _plus_7 = (_plus_6 + _property_7);
                OclExpression _expr_5 = b_3.getExpr();
                OclExpression _put = ib.put(_plus_7, _expr_5);
                _builder.append(_put, "");
                _builder.newLineIfNotEmpty();
              }
            }
          }
        }
      }
    }
    {
      OutPattern _output_2 = r.getOutput();
      EList<OutputElement> _elements_11 = _output_2.getElements();
      for(final OutputElement o_1 : _elements_11) {
        {
          EList<OutputBinding> _bindings_5 = o_1.getBindings();
          boolean _notEquals_2 = (!Objects.equal(_bindings_5, null));
          if (_notEquals_2) {
            {
              EList<OutputBinding> _bindings_6 = o_1.getBindings();
              for(final OutputBinding b_4 : _bindings_6) {
                String _varName_13 = o_1.getVarName();
                String _plus_8 = (_varName_13 + "_sep_");
                String _genOutputElementType = this.genOutputElementType(o_1);
                String _plus_9 = (_plus_8 + _genOutputElementType);
                String _plus_10 = (_plus_9 + ".");
                String _property_8 = b_4.getProperty();
                String _plus_11 = (_plus_10 + _property_8);
                OclExpression _expr_6 = b_4.getExpr();
                OclExpression _put_1 = ob.put(_plus_11, _expr_6);
                _builder.append(_put_1, "");
                _builder.newLineIfNotEmpty();
              }
            }
          }
        }
      }
    }
    {
      Set<String> _keySet = ib.keySet();
      for(final String k : _keySet) {
        String[] _split = k.split("_sep_");
        String obj = _split[0];
        _builder.newLineIfNotEmpty();
        String[] _split_1 = k.split("_sep_");
        String field = _split_1[1];
        _builder.newLineIfNotEmpty();
        {
          Set<String> _keySet_1 = ob.keySet();
          boolean _contains_1 = _keySet_1.contains(k);
          if (_contains_1) {
            {
              OclExpression _get_2 = ib.get(k);
              OclExpression _get_3 = ob.get(k);
              boolean _oclEqualCheck = this.oclEqualCheck(_get_2, _get_3);
              if (_oclEqualCheck) {
              } else {
                _builder.append("ensures read(");
                String _heapName_9 = this.getHeapName();
                _builder.append(_heapName_9, "");
                _builder.append(", ");
                _builder.append(obj, "");
                _builder.append(", ");
                _builder.append(field, "");
                _builder.append(") == ");
                OclExpression _get_4 = ob.get(k);
                CharSequence _printOCL_3 = this.printOCL(_get_4, true);
                _builder.append(_printOCL_3, "");
                _builder.append(";");
                _builder.newLineIfNotEmpty();
                {
                  boolean _containsKey_1 = frame.containsKey(obj);
                  if (_containsKey_1) {
                    String _xblockexpression_3 = null;
                    {
                      Set<String> _get_5 = frame.get(obj);
                      _get_5.add(field);
                      _xblockexpression_3 = "";
                    }
                    _builder.append(_xblockexpression_3, "");
                    _builder.newLineIfNotEmpty();
                  } else {
                    String _xblockexpression_4 = null;
                    {
                      HashSet<String> _hashSet = new HashSet<String>();
                      frame.put(obj, _hashSet);
                      _xblockexpression_4 = "";
                    }
                    _builder.append(_xblockexpression_4, "");
                    _builder.newLineIfNotEmpty();
                    String _xblockexpression_5 = null;
                    {
                      Set<String> _get_5 = frame.get(obj);
                      _get_5.add(field);
                      _xblockexpression_5 = "";
                    }
                    _builder.append(_xblockexpression_5, "");
                    _builder.newLineIfNotEmpty();
                  }
                }
              }
            }
          } else {
            _builder.append("ensures read(");
            String _heapName_10 = this.getHeapName();
            _builder.append(_heapName_10, "");
            _builder.append(", ");
            _builder.append(obj, "");
            _builder.append(", ");
            _builder.append(field, "");
            _builder.append(") == ");
            String _printDefaultVal = this.printDefaultVal(field);
            _builder.append(_printDefaultVal, "");
            _builder.append(";");
            _builder.newLineIfNotEmpty();
            _builder.append("ensures !isset(");
            String _setTableName_5 = this.getSetTableName();
            _builder.append(_setTableName_5, "");
            _builder.append(", ");
            _builder.append(obj, "");
            _builder.append(", ");
            _builder.append(field, "");
            _builder.append(");");
            _builder.newLineIfNotEmpty();
            {
              boolean _containsKey_2 = frame.containsKey(obj);
              if (_containsKey_2) {
                String _xblockexpression_6 = null;
                {
                  Set<String> _get_5 = frame.get(obj);
                  _get_5.add(field);
                  _xblockexpression_6 = "";
                }
                _builder.append(_xblockexpression_6, "");
                _builder.newLineIfNotEmpty();
              } else {
                String _xblockexpression_7 = null;
                {
                  HashSet<String> _hashSet = new HashSet<String>();
                  frame.put(obj, _hashSet);
                  _xblockexpression_7 = "";
                }
                _builder.append(_xblockexpression_7, "");
                _builder.newLineIfNotEmpty();
                String _xblockexpression_8 = null;
                {
                  Set<String> _get_5 = frame.get(obj);
                  _get_5.add(field);
                  _xblockexpression_8 = "";
                }
                _builder.append(_xblockexpression_8, "");
                _builder.newLineIfNotEmpty();
              }
            }
          }
        }
      }
    }
    {
      Set<String> _keySet_2 = ob.keySet();
      for(final String k_1 : _keySet_2) {
        {
          Set<String> _keySet_3 = ib.keySet();
          boolean _contains_2 = _keySet_3.contains(k_1);
          boolean _not = (!_contains_2);
          if (_not) {
            _builder.append("\t\t\t");
            String[] _split_2 = k_1.split("_sep_");
            String obj_1 = _split_2[0];
            _builder.newLineIfNotEmpty();
            String[] _split_3 = k_1.split("_sep_");
            String field_1 = _split_3[1];
            _builder.newLineIfNotEmpty();
            _builder.append("ensures read(");
            String _heapName_11 = this.getHeapName();
            _builder.append(_heapName_11, "");
            _builder.append(", ");
            _builder.append(obj_1, "");
            _builder.append(", ");
            _builder.append(field_1, "");
            _builder.append(") == ");
            OclExpression _get_5 = ob.get(k_1);
            CharSequence _printOCL_4 = this.printOCL(_get_5, true);
            _builder.append(_printOCL_4, "");
            _builder.append(";");
            _builder.newLineIfNotEmpty();
            _builder.append("ensures isset(");
            String _setTableName_6 = this.getSetTableName();
            _builder.append(_setTableName_6, "");
            _builder.append(", ");
            _builder.append(obj_1, "");
            _builder.append(", ");
            _builder.append(field_1, "");
            _builder.append(");");
            _builder.newLineIfNotEmpty();
            {
              boolean _containsKey_3 = frame.containsKey(obj_1);
              if (_containsKey_3) {
                String _xblockexpression_9 = null;
                {
                  Set<String> _get_6 = frame.get(obj_1);
                  _get_6.add(field_1);
                  _xblockexpression_9 = "";
                }
                _builder.append(_xblockexpression_9, "");
                _builder.newLineIfNotEmpty();
              } else {
                String _xblockexpression_10 = null;
                {
                  HashSet<String> _hashSet = new HashSet<String>();
                  frame.put(obj_1, _hashSet);
                  _xblockexpression_10 = "";
                }
                _builder.append(_xblockexpression_10, "");
                _builder.newLineIfNotEmpty();
                String _xblockexpression_11 = null;
                {
                  Set<String> _get_6 = frame.get(obj_1);
                  _get_6.add(field_1);
                  _xblockexpression_11 = "";
                }
                _builder.append(_xblockexpression_11, "");
                _builder.newLineIfNotEmpty();
              }
            }
          }
        }
      }
    }
    _builder.append("ensures (forall<alpha> o:ref,f:Field alpha::");
    _builder.newLine();
    _builder.append("  ");
    _builder.append("o!=null && read(old(");
    String _heapName_12 = this.getHeapName();
    _builder.append(_heapName_12, "  ");
    _builder.append("),o,alloc) ==> ");
    _builder.newLineIfNotEmpty();
    _builder.append("  ");
    _builder.append("(read(");
    String _heapName_13 = this.getHeapName();
    _builder.append(_heapName_13, "  ");
    _builder.append(",o,f)==read(old(");
    String _heapName_14 = this.getHeapName();
    _builder.append(_heapName_14, "  ");
    _builder.append("),o,f)) ||");
    _builder.newLineIfNotEmpty();
    {
      Set<String> _keySet_4 = frame.keySet();
      int _size_1 = _keySet_4.size();
      boolean _notEquals_3 = (_size_1 != 0);
      if (_notEquals_3) {
        {
          Set<String> _keySet_5 = frame.keySet();
          boolean _hasElements_2 = false;
          for(final String o_2 : _keySet_5) {
            if (!_hasElements_2) {
              _hasElements_2 = true;
            } else {
              _builder.appendImmediate("||", "  ");
            }
            _builder.append("  ");
            _builder.append("(o == ");
            _builder.append(o_2, "  ");
            _builder.append(" && (");
            {
              Set<String> _get_6 = frame.get(o_2);
              boolean _hasElements_3 = false;
              for(final String f : _get_6) {
                if (!_hasElements_3) {
                  _hasElements_3 = true;
                } else {
                  _builder.appendImmediate("||", "  ");
                }
                _builder.append(" f == ");
                _builder.append(f, "  ");
              }
            }
            _builder.append("))");
            _builder.newLineIfNotEmpty();
          }
        }
      }
    }
    _builder.append(");");
    _builder.newLine();
    _builder.append("ensures (forall<alpha> o:ref,f:Field alpha::");
    _builder.newLine();
    _builder.append("  ");
    _builder.append("(isset(");
    String _setTableName_7 = this.getSetTableName();
    _builder.append(_setTableName_7, "  ");
    _builder.append(",o,f)==isset(old(");
    String _setTableName_8 = this.getSetTableName();
    _builder.append(_setTableName_8, "  ");
    _builder.append("),o,f)) ||");
    _builder.newLineIfNotEmpty();
    {
      Set<String> _keySet_6 = frame.keySet();
      int _size_2 = _keySet_6.size();
      boolean _notEquals_4 = (_size_2 != 0);
      if (_notEquals_4) {
        {
          Set<String> _keySet_7 = frame.keySet();
          boolean _hasElements_4 = false;
          for(final String o_3 : _keySet_7) {
            if (!_hasElements_4) {
              _hasElements_4 = true;
            } else {
              _builder.appendImmediate("||", "  ");
            }
            _builder.append("  ");
            _builder.append("(o == ");
            _builder.append(o_3, "  ");
            _builder.append(" && (");
            {
              Set<String> _get_7 = frame.get(o_3);
              boolean _hasElements_5 = false;
              for(final String f_1 : _get_7) {
                if (!_hasElements_5) {
                  _hasElements_5 = true;
                } else {
                  _builder.appendImmediate("||", "  ");
                }
                _builder.append(" f == ");
                _builder.append(f_1, "  ");
              }
            }
            _builder.append("))");
            _builder.newLineIfNotEmpty();
          }
        }
      }
    }
    _builder.append(");");
    _builder.newLine();
    return _builder;
  }
  
  public String printDefaultVal(final String s) {
    String v = this.fMap.get(s);
    boolean _equals = Objects.equal(v, "int");
    if (_equals) {
      return "0";
    } else {
      boolean _equals_1 = Objects.equal(v, "string");
      if (_equals_1) {
        return "Seq#Empty()";
      } else {
        boolean _equals_2 = Objects.equal(v, "bool");
        if (_equals_2) {
          return "false";
        } else {
          return "null";
        }
      }
    }
  }
  
  public String getModel(final OclType type) {
    if ((type instanceof OclModelElement)) {
      OclModel _model = ((OclModelElement)type).getModel();
      return _model.getName();
    } else {
      return "unknown";
    }
  }
  
  public ArrayList<OutputElement> listDifference1(final EList<OutputElement> outs, final EList<InputElement> ins) {
    ArrayList<OutputElement> r = new ArrayList<OutputElement>();
    for (final OutputElement o : outs) {
      {
        boolean add = true;
        for (final InputElement i : ins) {
          String _varName = o.getVarName();
          String _varName_1 = i.getVarName();
          boolean _equals = Objects.equal(_varName, _varName_1);
          if (_equals) {
            add = false;
          }
        }
        if (add) {
          r.add(o);
        }
      }
    }
    return r;
  }
  
  public ArrayList<InputElement> listDifference2(final EList<OutputElement> outs, final EList<InputElement> ins) {
    ArrayList<InputElement> r = new ArrayList<InputElement>();
    for (final InputElement i : ins) {
      {
        boolean del = true;
        for (final OutputElement o : outs) {
          String _varName = o.getVarName();
          String _varName_1 = i.getVarName();
          boolean _equals = Objects.equal(_varName, _varName_1);
          if (_equals) {
            del = false;
          }
        }
        if (del) {
          r.add(i);
        }
      }
    }
    return r;
  }
  
  public String genInputSequence(final EList<InputElement> list) {
    String _xblockexpression = null;
    {
      int i = 0;
      String r = "";
      for (final InputElement e : list) {
        {
          if ((i == 0)) {
            String _r = r;
            String _varName = e.getVarName();
            String _plus = ("Seq#Singleton(" + _varName);
            String _plus_1 = (_plus + ")");
            r = (_r + _plus_1);
          } else {
            String _varName_1 = e.getVarName();
            String _plus_2 = ((("Seq#Build(" + r) + ",") + _varName_1);
            String _plus_3 = (_plus_2 + ")");
            r = _plus_3;
          }
          i++;
        }
      }
      _xblockexpression = r;
    }
    return _xblockexpression;
  }
  
  public String getHeapName() {
    return "$srcHeap";
  }
  
  public String getSetTableName() {
    return "$acc";
  }
  
  public String getBHeap() {
    return "_hp";
  }
  
  public boolean oclEqualCheck(final OclExpression expr1, final OclExpression expr2) {
    boolean _xifexpression = false;
    EClass _eClass = expr1.eClass();
    String _name = _eClass.getName();
    EClass _eClass_1 = expr2.eClass();
    String _name_1 = _eClass_1.getName();
    boolean _notEquals = (!Objects.equal(_name, _name_1));
    if (_notEquals) {
      _xifexpression = false;
    } else {
      boolean _switchResult = false;
      EClass _eClass_2 = expr1.eClass();
      String _name_2 = _eClass_2.getName();
      boolean _matched = false;
      if (!_matched) {
        if (Objects.equal(_name_2, "VariableExp")) {
          _matched=true;
          boolean _xifexpression_1 = false;
          VariableDeclaration _referredVariable = ((VariableExp) expr1).getReferredVariable();
          String _varName = _referredVariable.getVarName();
          VariableDeclaration _referredVariable_1 = ((VariableExp) expr2).getReferredVariable();
          String _varName_1 = _referredVariable_1.getVarName();
          boolean _equals = Objects.equal(_varName, _varName_1);
          if (_equals) {
            _xifexpression_1 = true;
          } else {
            _xifexpression_1 = false;
          }
          _switchResult = _xifexpression_1;
        }
      }
      if (!_matched) {
        if (Objects.equal(_name_2, "IntegerExp")) {
          _matched=true;
          boolean _xifexpression_2 = false;
          int _integerSymbol = ((IntegerExp) expr1).getIntegerSymbol();
          int _integerSymbol_1 = ((IntegerExp) expr2).getIntegerSymbol();
          boolean _equals_1 = (_integerSymbol == _integerSymbol_1);
          if (_equals_1) {
            _xifexpression_2 = true;
          } else {
            _xifexpression_2 = false;
          }
          _switchResult = _xifexpression_2;
        }
      }
      if (!_matched) {
        _switchResult = false;
      }
      _xifexpression = _switchResult;
    }
    return _xifexpression;
  }
  
  protected CharSequence _printOCL(final OclExpression expr, final boolean old) {
    StringConcatenation _builder = new StringConcatenation();
    return _builder;
  }
  
  protected CharSequence _printOCL(final IntegerExp expr, final boolean old) {
    StringConcatenation _builder = new StringConcatenation();
    int _integerSymbol = expr.getIntegerSymbol();
    _builder.append(_integerSymbol, "");
    return _builder;
  }
  
  protected CharSequence _printOCL(final VariableExp expr, final boolean old) {
    StringConcatenation _builder = new StringConcatenation();
    VariableDeclaration _referredVariable = expr.getReferredVariable();
    String _varName = _referredVariable.getVarName();
    _builder.append(_varName, "");
    return _builder;
  }
  
  protected CharSequence _printOCL(final PropertyCallExp expr, final boolean old) {
    StringConcatenation _builder = new StringConcatenation();
    {
      EList<PropertyCall> _calls = expr.getCalls();
      for(final PropertyCall call : _calls) {
        {
          boolean _and = false;
          OclExpression _source = expr.getSource();
          if (!(_source instanceof VariableExp)) {
            _and = false;
          } else {
            _and = (call instanceof NavigationOrAttributeCall);
          }
          if (_and) {
            _builder.append(" read(");
            {
              if (old) {
                _builder.append("old(");
                String _heapName = this.getHeapName();
                _builder.append(_heapName, "");
                _builder.append(")");
              } else {
                String _heapName_1 = this.getHeapName();
                _builder.append(_heapName_1, "");
              }
            }
            _builder.append(", ");
            OclExpression _source_1 = expr.getSource();
            VariableDeclaration _referredVariable = ((VariableExp) _source_1).getReferredVariable();
            String _varName = _referredVariable.getVarName();
            _builder.append(_varName, "");
            _builder.append(", ");
            OclExpression _source_2 = expr.getSource();
            VariableDeclaration _referredVariable_1 = ((VariableExp) _source_2).getReferredVariable();
            OclType _type = _referredVariable_1.getType();
            String _model = this.getModel(_type);
            _builder.append(_model, "");
            _builder.append("$");
            OclExpression _source_3 = expr.getSource();
            VariableDeclaration _referredVariable_2 = ((VariableExp) _source_3).getReferredVariable();
            OclType _type_1 = _referredVariable_2.getType();
            String _name = _type_1.getName();
            _builder.append(_name, "");
            _builder.append(".");
            String _name_1 = ((NavigationOrAttributeCall) call).getName();
            _builder.append(_name_1, "");
            _builder.append(")");
          }
        }
        _builder.append("\t");
      }
    }
    return _builder;
  }
  
  protected CharSequence _printOCL(final AddOpCallExp expr, final boolean old) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append(" ");
    OclExpression _source = expr.getSource();
    Object _printOCL = this.printOCL(_source, true);
    _builder.append(_printOCL, " ");
    _builder.append("+");
    OclExpression _argument = expr.getArgument();
    Object _printOCL_1 = this.printOCL(_argument, true);
    _builder.append(_printOCL_1, " ");
    _builder.append(" ");
    return _builder;
  }
  
  public CharSequence generateModule_applys(final EObject mod) {
    if (mod instanceof Module) {
      return _generateModule_applys((Module)mod);
    } else if (mod != null) {
      return _generateModule_applys(mod);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(mod).toString());
    }
  }
  
  public CharSequence generateModule_matches(final EObject mod) {
    if (mod instanceof Module) {
      return _generateModule_matches((Module)mod);
    } else if (mod != null) {
      return _generateModule_matches(mod);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(mod).toString());
    }
  }
  
  public CharSequence generateModule_sfs(final EObject mod) {
    if (mod instanceof Module) {
      return _generateModule_sfs((Module)mod);
    } else if (mod != null) {
      return _generateModule_sfs(mod);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(mod).toString());
    }
  }
  
  public CharSequence genModuleElement_apply(final ModuleElement r) {
    if (r instanceof Rule) {
      return _genModuleElement_apply((Rule)r);
    } else if (r != null) {
      return _genModuleElement_apply(r);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(r).toString());
    }
  }
  
  public CharSequence genModuleElement_match(final ModuleElement r) {
    if (r instanceof Rule) {
      return _genModuleElement_match((Rule)r);
    } else if (r != null) {
      return _genModuleElement_match(r);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(r).toString());
    }
  }
  
  public CharSequence genStructuralPatternMatch(final ModuleElement r) {
    if (r instanceof Rule) {
      return _genStructuralPatternMatch((Rule)r);
    } else if (r != null) {
      return _genStructuralPatternMatch(r);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(r).toString());
    }
  }
  
  public CharSequence printOCL(final OclExpression expr, final boolean old) {
    if (expr instanceof IntegerExp) {
      return _printOCL((IntegerExp)expr, old);
    } else if (expr instanceof AddOpCallExp) {
      return _printOCL((AddOpCallExp)expr, old);
    } else if (expr instanceof PropertyCallExp) {
      return _printOCL((PropertyCallExp)expr, old);
    } else if (expr instanceof VariableExp) {
      return _printOCL((VariableExp)expr, old);
    } else if (expr != null) {
      return _printOCL(expr, old);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(expr, old).toString());
    }
  }
}
