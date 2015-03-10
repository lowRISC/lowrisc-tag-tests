#! /usr/bin/env python

import sys
import os
from subprocess import Popen # now we can make system calls
from subprocess import PIPE  # now we can make system calls

NumRequests=[1,2,4,8,16,20]
AppSize=[4,16,32,64,512,1024,2048,4192,5000,6000,8192,16384,50100,75100,100000,262144,300100]
NumIterations=[300100]

def runBash(cmd):
    p = Popen(cmd, shell=True, stdout=PIPE)
    out = p.stdout.read().strip()
    return out #This is the stdout from the shell command

def main():
    CMD_PREFIX = sys.argv[1]
    CMD_SUFFIX = sys.argv[2]
    CMD_BASE_DIR = sys.argv[3]

    reportFile = "ccbench_band_req.result"
    if os.path.isfile(reportFile): os.remove(reportFile)

    testTarget = CMD_BASE_DIR + "/band_req"

    for appIter in NumIterations:
        for appNReq in NumRequests:
            for appSize in AppSize:
                cmd = CMD_PREFIX + " " + testTarget + " " + str(appNReq) + " " + str(appSize) + " " + str(appIter) + " " + CMD_SUFFIX 
                print cmd
                value = runBash(cmd)
                if value != "": print value

if __name__ == "__main__":
    main()
