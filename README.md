# Compiler.Emftvm2Boogie

## Aim
In this work, we develop a formalisation for the EMFTVM bytecode language by using the Boogie intermediate verification language. 
It ensures the model transformation language has an implementable execution semantics by reliably prototyping the implementation of the model transformation language. 
It also ensures the absence of erroneous execution semantics encoded for the target model transformation language by using a translation validation approach. This repository contains the source code to witness the feasibility of our approach.

## Structure
* fr.emn.atlanmod.emftvm.compiler: source code for compiling .emftvm EMFTVM bytecode to .bpl Boogie file.
* fr.emn.atlanmod.emftvm.resolve: Boogie source code for reliable prototyping resolve algorithm, draw on the operational semantics of EMFTVM bytecode in Boogie.
* fr.emn.atlanmod.veriatl.compiler: source code for translation validation atl transformations.
  * contains Xpand source code that generate semantics of ecore metamodel.
  * contains Xpand source code that generate execution semantics of atl.
  * depend on⋅**fr.emn.atlanmod.emftvm.compiler** to generate runtime behaviour of atl.
  * contains case studies of translation validation **ER2REL** and **HSM2FSM** atl transformations.
  * guide of how to execute veriatl (manual.pdf).
* fr.emn.atlanmod.verigt.compiler: source code for translation validation simplegt graph transformations.
  * contains Xpand source code that generate semantics of ecore metamodel.
  * contains Xtend source code that generate execution semantics of simplegt.
  * depend on⋅**fr.emn.atlanmod.emftvm.compiler** to generate runtime behaviour of simplegt.
  * contains case studies of translation validation **Pacman** simplegt transformation.
  * guide of how to execute verigt (manual.pdf).
* fr.emn.atlanmod.emftvm.casestudies.standalone: stand alone python application to run the case studies.
  * Generated Boogie Code for case studies (by veriatl and verigt).
  * Python driver to count timing and LoC of case studies.
  * Timing and LoC results.
 
## Requires
We have tested our approach using the following setup:
* Boogie 2.2 + Z3 4.3
* Eclipse Mars + Eclipse Modeling Tools 4.5.2
* Xtend 2.2.0 + Xpand 2.2.0
* SimpleGT 2.0.2
* SimpleOCL 2.0.2
* ATL EMFTVM 3.7.0
* ATL 3.7.0






