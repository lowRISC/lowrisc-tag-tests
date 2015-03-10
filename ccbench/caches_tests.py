#! /usr/bin/env python

import sys
import os
from subprocess import Popen # now we can make system calls
from subprocess import PIPE  # now we can make system calls

AppSizeArg=[4,16,32,64,512,1024,2048,4192,5000,6000,7000, 8192,9000,10000,12000,16384, 24576, 29696, 32768, 35840,37000, 40000, 50100, 60000, 62000,65536,68000,  70000,  75100,100000,131072,229376,262144,300100,400100]
NumIterations=[300100]
RunType=[1,16,0]

def runBash(cmd):
    p = Popen(cmd, shell=True, stdout=PIPE)
    out = p.stdout.read().strip()
    return out #This is the stdout from the shell command

def main():
    CMD_PREFIX = sys.argv[1]
    CMD_SUFFIX = sys.argv[2]
    CMD_BASE_DIR = sys.argv[3]

    reportFile = "ccbench_caches.result"
    if os.path.isfile(reportFile): os.remove(reportFile)

    testTarget = CMD_BASE_DIR + "/caches"

    for appRT in RunType:
        for appIter in NumIterations:
            for appSize in AppSizeArg:
                cmd = CMD_PREFIX + " " + testTarget + " " + str(appSize) + " " + str(appIter) + " " + str(appRT) + " " + CMD_SUFFIX 
                print cmd
                value = runBash(cmd)
                if value != "": print value

if __name__ == "__main__":
    main()
