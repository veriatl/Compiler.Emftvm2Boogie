VeriATL Quick Tour v1.0 
===
- configure veriATL.conf
  - give the Boogie project name that VeriATL verifies against.
  - give the path of Boogie.exe.
- Navigate to the package **cs.nuim.ie.workflowRunner.xpandExec.java* (fr.emn.atlanmod.veriatl.compiler) is the entry point of the VeriATL compiler. 
- Run the entry point to get the skeleton of a Boogie project, e.g.
  - Copy ATL source files into the corresponding folder, e.g. for veriATL the following are needed:
  - model of ATL source file (ATL)
  - ATL source file (ATLSRC)
  - compiled EMFTVM file of ATL source (EMFTVM)
  - SRC/TAR Metamodel (SRCMM/TARMM)
- Next, uncommented the following line in "xpandExec.java" , and then run the Java program to generate the corresponding Boogie code: 
  - genMetamodels(projName). Generate Boogie code for source and target metamodel under "/PROJNAME/Metamodels/". 
  - genExecSem(projName). Generate Boogie code for execution semantics of ATL transformation under "/PROJNAME/ExecutionSemantics". 
  - genRuntime(projName). Generate Boogie code for runtime behaviours of ATL transformation under "/PROJNAME/ATL_Rule_Encoding/". 
  - GenExternalConfigruation. Generate eclipse configuration file to automatically perform translation validation on the given Boogie project.
