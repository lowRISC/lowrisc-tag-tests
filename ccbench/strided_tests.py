#! /usr/bin/env python

import sys
import os
from subprocess import Popen # now we can make system calls
from subprocess import PIPE  # now we can make system calls

NumThreads=[1]
AppSize=[32,64, 128, 256, 512, 1024]
AppStride=[1, 2, 4]
NumIterations=[50]

def runBash(cmd):
    p = Popen(cmd, shell=True, stdout=PIPE)
    out = p.stdout.read().strip()
    return out #This is the stdout from the shell command

def main():
    CMD_PREFIX = sys.argv[1]
    CMD_SUFFIX = sys.argv[2]
    CMD_BASE_DIR = sys.argv[3]

    reportFile = "ccbench_strided.result"
    if os.path.isfile(reportFile): os.remove(reportFile)

    testTarget = CMD_BASE_DIR + "/strided"

    for appIter in NumIterations:
        for appSize in AppSize:
            for appStride in AppStride:
                cmd = CMD_PREFIX + " " + testTarget + " 1 " + str(appSize) + " " + str(appStride) + " " + str(appIter) + " " + " >> " + reportFile + " " + CMD_SUFFIX 
                print cmd
                value = runBash(cmd)
                if value != "": print value

if __name__ == "__main__":
    main()
