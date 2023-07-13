#!/usr/bin/env python

import subprocess
import os
import sys

GPUFPX_loadcommand="LD_PRELOAD=../../../GPU-FPX-ana.so "
excloctypecsv_file="exc-loc-type.csv"
print_extra = True

def read_from_excloctypecsv():
    with open(excloctypecsv_file) as f:
        return [l.split("\n")[0].split(",") for l in f.readlines() ]
def setup_module(module):
    THIS_DIR = os.path.dirname(os.path.abspath(__file__))
    os.chdir(THIS_DIR)

def teardown_module(module):
    cmd = ["make clean"]
    cmdOutput = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)

def run_command(cmd):
    try:
        cmdOutput = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
    except subprocess.CalledProcessError as e:
        print(e.output)
        exit()
    return cmdOutput

def check_in_desire(desire,line):
    for tuple_ in desire:
        if(tuple_[0] in line and tuple_[1] in line and tuple_[2] in line):
            return tuple_
    return False

def verify_except(desire,exe):
    # --- run code ---
    cmd = [GPUFPX_loadcommand + exe]
    #print(cmd)
    output = run_command(cmd)
    #print(output.decode('utf-8').split("\n"))

    for line in output.decode('utf-8').split("\n"):
        if("GPU-FPX LOC-EXCEP INFO" in line):
            tuple_ = check_in_desire(desire, line)
            if(tuple_ != False): 
                desire.remove(tuple_)
            else:
                if(print_extra):
                    print("\033[94m"+line)

    if(len(desire)==0):
        print(f"\033[92mPASS")
    else:
        print(f"\033[91mFAIL")
        for t in desire:
            print("\033[91m"+','.join(t))

if __name__ == "__main__":
    exe = sys.argv[1]
    desire = read_from_excloctypecsv()
    verify_except(desire, exe)
