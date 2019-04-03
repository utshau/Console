import sys, os.path

def all_from(folder='', abspath=None):
    add = set(sys.path)
    if abspath is None:
        cwd = os.path.abspath(os.path.curdir)
        abspath = os.path.join(cwd, folder)
    for root, dirs, files in os.walk(abspath):
        for f in files:
            if f[-3] in '.py':
                add.add(root)
                break
    for i in add: sys.path.append(i)