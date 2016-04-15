import subprocess
from os import walk
import sys
from datetime import datetime
import time

# global settings start
# VERIFICATION OPTION ON PROJECTS
_OPT_VERIFICATION = 1		# CORRECTNESS VERIFICATION
_OPT_VALIDATION = 2			# TRANSLATION VALIDITON


LibsPath = "Prelude/"		# imported library path
mmPath = "Metamodels/"			# imported metamodel path


# PROJ PATH
Proj0 = "Resolve/"
Proj1 = "ER2REL/"			# task 2
Proj2 = "HSM2FSM/"			# task 1
Proj3 = "Pacman/"			# task 2



# PROJ TO VERIFY
Projs = [Proj0]	

# WHAT OPTION TO VERIFY EACH PROJ
Projs_option_map = { Proj1: { _OPT_VALIDATION}, 
                     Proj2: { _OPT_VALIDATION},
                     Proj3: { _OPT_VALIDATION},
                     Proj0: { _OPT_VALIDATION}

				}

# BOOGIE ARGS


# global settings end

# forge the cmd that executes Boogie, depending on the [option] that pass in, which stores at task_option_map.
def forgeRunningCommand(projPath, taskName, option):
	command = []

	command.append("boogie")					# command
	

	
	
	
	for libName in loadFiles(LibsPath):
		command.append(LibsPath+libName)		# importing library

	
	for fN in loadFiles(projPath+mmPath):
		command.append(projPath+mmPath+fN)				# import metamodel related Boogie code


	command.append(projPath+"ExecutionSemantics/ATL_apply.bpl")
	command.append(projPath+"ExecutionSemantics/ATL_match.bpl")

	
	if option == _OPT_VALIDATION :
		command.append(projPath+"ATL_Rule_Encoding/"+taskName)	# input


	return command


	
def loadFiles(path):
	
	f = []
	for (dirpath, dirnames, filenames) in walk(path):
		f.extend(filenames)
		break

	return f



def BatchTest(isDetailed):

	sum = 0;
	
	for proj in Projs:

		for opt in Projs_option_map[proj]:
				
			if opt == _OPT_VALIDATION:
				
				tasks = loadFiles(proj+"/ATL_Rule_Encoding/")	
			else:
				break;
		
			for task in tasks:
				myCmd = forgeRunningCommand(proj, task, opt)

				start = time.time()
				p = subprocess.Popen(myCmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE) 
				done = time.time()
				out, err = p.communicate()
				elapsed = done - start
				sum+=elapsed
				
				print(task+": "+ str(elapsed))
				
				
				
					
		print(sum)
	

	

	
def main():
	i = datetime.now()
	
	BatchTest(True)
	
	
	

if __name__ == "__main__":
    main()
	
	
