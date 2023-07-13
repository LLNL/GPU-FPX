import glob,os.path
from subprocess import call

with open("valid-programs.txt") as f:
    x=f.readlines()
    valid_programs = [i.split("\n")[0] for i in x]

files = glob.glob("./Samples/*/**")
dirs = filter(lambda f: os.path.isdir(f), files)
all_dirs = [j for j in dirs]
for d in all_dirs:
    if d not in valid_programs:
        print(d)
        call(["rm","-rf",d])
