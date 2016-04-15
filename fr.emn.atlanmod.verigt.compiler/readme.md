VeriGT Quick Tour v1.0 
===
- configure veriGT.conf
  - give the Boogie project name that VeriGT verifies against.
  - give the path of Boogie.exe.
- Navigate to the package *cs.nuim.ie.workflowRunner. xpandExec.java* (fr.emn.atlanmod.verigt.compiler) is the entry point of the VeriGT compiler. 
- Run the entry point to get the skeleton of a Boogie project, e.g.
  - Copy SimpleGT source files into the corresponding folder:
  - model of SimpleGT source file (SimpleGT)
  - SimpleGT source file (SimpleGTSRC)
  - compiled EMFTVM file of SimpleGT source (EMFTVM)
  - SRC Metamodel (SRCMM)
- Next, uncommented the following line in "xpandExec.java" , and then run the Java program to generate the corresponding Boogie code: 
  - genMetamodels(projName). Generate Boogie code for source and target metamodel under "/PROJNAME/Metamodels/". 
  - genExecSem(projName). Generate Boogie code for execution semantics of SimpleGT transformation under "/PROJNAME/ExecutionSemantics". 
  - genRuntime(projName). Generate Boogie code for runtime behaviours of SimpleGT transformation under "/PROJNAME/SimpleGT_Rule_Encoding/". 
  - GenExternalConfigruation. Generate eclipse configuration file to automatically perform translation validation on the given Boogie project.
