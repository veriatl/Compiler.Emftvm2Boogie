# Compiler.Emftvm2Boogie

## Aim
In this work, we develop a formalisation for the EMFTVM bytecode language by using the Boogie intermediate verification language. 
It ensures the model transformation language has an implementable execution semantics by reliably prototyping the implementation of the model transformation language. 
It also ensures the absence of erroneous execution semantics encoded for the target model transformation language by using a translation validation approach. This repository contains the source code to witness the feasibility of our approach.

## Structure
* fr.emn.atlanmod.emftvm.compiler: source code for compiling .emftvm EMFTVM bytecode to .bpl Boogie file.
* fr.emn.atlanmod.veriatl.compiler: source code for translation validation atl transformations.
  * contains xpand source code that generate execution semantics of atl.
  * depend on⋅**fr.emn.atlanmod.emftvm.compiler** to generate runtime behaviour of atl.
  * contains case studies of translation validation **ER2REL** and **HSM2FSM** atl transformations.
* fr.emn.atlanmod.verigt.compiler: source code for translation validation simplegt graph transformations.
  * contains xtend source code that generate execution semantics of simplegt.
  * depend on⋅**fr.emn.atlanmod.emftvm.compiler** to generate runtime behaviour of simplegt.
  * contains case studies of translation validation **Pacman** simplegt transformation.







