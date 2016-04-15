import os
import fnmatch

def Walk(root='.', recurse=True, pattern='*'):
    for path, subdirs, files in os.walk(root):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                yield os.path.join(path, name)
        if not recurse:
            break

def LOC(root='', recurse=True):
    count_maxi = 0
    for fspec in Walk(root, recurse, '*.bpl'):
        skip = False
        for line in open(fspec).readlines():
            count_maxi += 1

    return str(count_maxi)

print("Resolve: "+LOC("Resolve", True))
print("ER2REL: "+LOC("ER2REL", True))
print("HSM2FSM: "+LOC("HSM2FSM", True))
print("Pacman: "+LOC("Pacman", True))
