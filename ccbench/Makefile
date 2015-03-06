#=======================================================================
# Makefile for ccbench tests
#-----------------------------------------------------------------------

default: all

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_PREFIX=riscv64-unknown-elf-
RISCV_GCC = $(RISCV_PREFIX)gcc
RISCV_LINUX_PREFIX=riscv64-unknown-linux-gnu-
RISCV_LINUX_GCC = $(RISCV_LINUX_PREFIX)gcc

RISCV_GCC_OPTS = -I. -std=gnu99 -O2 -ffast-math -funroll-loops
RISCV_LINK_OPTS = -lm -lc
RISCV_LINUX_GCC_OPTS = -I.. -O3 -static

#--------------------------------------------------------------------
# Build targets
#--------------------------------------------------------------------
common_files = cctimer barrier cclfsr
common_objs = $(addsuffix .o, $(common_files))

ccbench_tests = caches band_req mem_interleaving strided

ccbench_tests_linux = $(addsuffix .linux, $(ccbench_tests))

#--------------------------------------------------------------------
# Build
#--------------------------------------------------------------------

$(ccbench_tests): %:%.o $(common_objs)
	$(RISCV_GCC) $(RISCV_GCC_OPTS) $^ $(RISCV_LINK_OPTS) -o $@

%.o: %.c
	$(RISCV_GCC) -c $(RISCV_GCC_OPTS) $< -o $@

all: $(ccbench_tests)

linux: $(ccbench_tests_linux)

clean:
	rm -fr $(ccbench_tests) $(ccbench_tests_linux) $(common_objs)
