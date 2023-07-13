#!/usr/bin/env python

import subprocess
import os

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

def test_1():
    # --- compile code ---
    cmd = ["make -f Makefile"]
    run_command(cmd)

    # --- run code ---
    cmd = ["LD_PRELOAD=../../detect_fp_exceptions.so ./main"]
    output = run_command(cmd)

    found = False
    for l in output.decode('utf-8').split("\n"):
      if "#FPCHECKER: INF found" in l:
        found = True

    assert found

if __name__ == "__main__":
  test_1()


